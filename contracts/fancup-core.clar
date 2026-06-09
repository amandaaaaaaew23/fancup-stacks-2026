;; FanCup Stacks 2026 - Core Contract
;; Onchain football prediction & fan voting arena built on Stacks.
;; No gambling, no betting pool. This contract uses fan points, predictions, check-ins, and team boosts.

(define-constant CONTRACT_OWNER tx-sender)

;; ERRORS
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_JOINED (err u101))
(define-constant ERR_NOT_JOINED (err u102))
(define-constant ERR_INVALID_TEAM (err u103))
(define-constant ERR_MATCH_NOT_FOUND (err u104))
(define-constant ERR_MATCH_CLOSED (err u105))
(define-constant ERR_ALREADY_PREDICTED (err u106))
(define-constant ERR_RESULT_NOT_SET (err u107))
(define-constant ERR_ALREADY_CLAIMED (err u108))
(define-constant ERR_ALREADY_CHECKED_IN (err u109))
(define-constant ERR_INSUFFICIENT_POINTS (err u110))
(define-constant ERR_PAUSED (err u111))
(define-constant ERR_INVALID_BLOCK_RANGE (err u112))
(define-constant ERR_INVALID_PICK (err u113))
(define-constant ERR_INVALID_SCORE_A (err u114))
(define-constant ERR_INVALID_SCORE_B (err u115))
(define-constant ERR_MATCH_NOT_CLOSED (err u116))
(define-constant ERR_INVALID_AMOUNT (err u117))
(define-constant ERR_INVALID_PRINCIPAL (err u118))

;; STATE
(define-data-var owner principal CONTRACT_OWNER)
(define-data-var paused bool false)
(define-data-var next-match-id uint u1)
(define-data-var total-players uint u0)

;; MAPS
(define-map admins principal bool)

(define-map players
  principal
  {
    joined: bool,
    team-id: uint,
    points: uint,
    streak: uint,
    last-checkin: uint,
    total-correct: uint,
    total-predictions: uint
  }
)

(define-map matches
  uint
  {
    team-a: uint,
    team-b: uint,
    start-block: uint,
    close-block: uint,
    score-a: uint,
    score-b: uint,
    result-set: bool,
    finalized: bool
  }
)

(define-map winner-predictions
  { user: principal, match-id: uint }
  {
    pick: uint,
    claimed: bool
  }
)

(define-map score-predictions
  { user: principal, match-id: uint }
  {
    score-a: uint,
    score-b: uint,
    claimed: bool
  }
)

(define-map team-boosts uint uint)

;; PRIVATE HELPERS
(define-private (is-owner)
  (is-eq tx-sender (var-get owner))
)

(define-private (is-admin)
  (or
    (is-owner)
    (default-to false (map-get? admins tx-sender))
  )
)

(define-private (assert-not-paused)
  (if (var-get paused)
    ERR_PAUSED
    (ok true)
  )
)

(define-private (valid-team (team-id uint))
  (and (> team-id u0) (<= team-id u64))
)

;; pick rule:
;; u0 = draw
;; u1 = team-a win
;; u2 = team-b win
(define-private (get-result-pick (score-a uint) (score-b uint))
  (if (> score-a score-b)
    u1
    (if (> score-b score-a)
      u2
      u0
    )
  )
)

;; READ ONLY
(define-read-only (get-player (user principal))
  (map-get? players user)
)

(define-read-only (get-match (match-id uint))
  (map-get? matches match-id)
)

(define-read-only (get-team-boost (team-id uint))
  (default-to u0 (map-get? team-boosts team-id))
)

(define-read-only (has-predicted-winner (user principal) (match-id uint))
  (is-some (map-get? winner-predictions { user: user, match-id: match-id }))
)

(define-read-only (get-winner-prediction (user principal) (match-id uint))
  (map-get? winner-predictions { user: user, match-id: match-id })
)

(define-read-only (get-score-prediction (user principal) (match-id uint))
  (map-get? score-predictions { user: user, match-id: match-id })
)

(define-read-only (get-owner)
  (var-get owner)
)

(define-read-only (get-total-players)
  (var-get total-players)
)

(define-read-only (get-next-match-id)
  (var-get next-match-id)
)

(define-read-only (is-paused)
  (var-get paused)
)

(define-read-only (is-admin-address (admin principal))
  (default-to false (map-get? admins admin))
)

;; ADMIN FUNCTIONS
(define-public (set-admin (admin principal) (enabled bool))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (asserts! (is-standard admin) ERR_INVALID_PRINCIPAL)
    (map-set admins admin enabled)
    (ok true)
  )
)

(define-public (set-paused (value bool))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (var-set paused value)
    (ok true)
  )
)

(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (asserts! (is-standard new-owner) ERR_INVALID_PRINCIPAL)
    (var-set owner new-owner)
    (ok true)
  )
)

;; USER FUNCTIONS
(define-public (join-tournament)
  (let
    (
      (existing (map-get? players tx-sender))
    )
    (try! (assert-not-paused))
    (asserts! (is-none existing) ERR_ALREADY_JOINED)

    (map-set players tx-sender {
      joined: true,
      team-id: u0,
      points: u0,
      streak: u0,
      last-checkin: u0,
      total-correct: u0,
      total-predictions: u0
    })

    (var-set total-players (+ (var-get total-players) u1))
    (ok true)
  )
)

(define-public (choose-team (team-id uint))
  (let
    (
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
    )
    (try! (assert-not-paused))
    (asserts! (valid-team team-id) ERR_INVALID_TEAM)

    (map-set players tx-sender
      (merge player { team-id: team-id })
    )

    (ok true)
  )
)

;; ADMIN / KEEPER FRIENDLY
(define-public (create-match (team-a uint) (team-b uint) (start-block uint) (close-block uint))
  (let
    (
      (match-id (var-get next-match-id))
    )
    (asserts! (is-admin) ERR_UNAUTHORIZED)
    (asserts! (valid-team team-a) ERR_INVALID_TEAM)
    (asserts! (valid-team team-b) ERR_INVALID_TEAM)
    (asserts! (< start-block close-block) ERR_INVALID_BLOCK_RANGE)

    (map-set matches match-id {
      team-a: team-a,
      team-b: team-b,
      start-block: start-block,
      close-block: close-block,
      score-a: u0,
      score-b: u0,
      result-set: false,
      finalized: false
    })

    (var-set next-match-id (+ match-id u1))
    (ok match-id)
  )
)

(define-public (predict-winner (match-id uint) (pick uint))
  (let
    (
      (match-data (unwrap! (map-get? matches match-id) ERR_MATCH_NOT_FOUND))
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
    )
    (try! (assert-not-paused))
    (asserts! (< stacks-block-height (get close-block match-data)) ERR_MATCH_CLOSED)
    (asserts! (or (is-eq pick u0) (or (is-eq pick u1) (is-eq pick u2))) ERR_INVALID_PICK)
    (asserts! (is-none (map-get? winner-predictions { user: tx-sender, match-id: match-id })) ERR_ALREADY_PREDICTED)

    (map-set winner-predictions { user: tx-sender, match-id: match-id } {
      pick: pick,
      claimed: false
    })

    (map-set players tx-sender
      (merge player {
        total-predictions: (+ (get total-predictions player) u1)
      })
    )

    (ok true)
  )
)

(define-public (predict-score (match-id uint) (score-a uint) (score-b uint))
  (let
    (
      (match-data (unwrap! (map-get? matches match-id) ERR_MATCH_NOT_FOUND))
    )
    (try! (assert-not-paused))
    (asserts! (is-some (map-get? players tx-sender)) ERR_NOT_JOINED)
    (asserts! (< stacks-block-height (get close-block match-data)) ERR_MATCH_CLOSED)
    (asserts! (<= score-a u20) ERR_INVALID_SCORE_A)
    (asserts! (<= score-b u20) ERR_INVALID_SCORE_B)
    (asserts! (is-none (map-get? score-predictions { user: tx-sender, match-id: match-id })) ERR_ALREADY_PREDICTED)

    (map-set score-predictions { user: tx-sender, match-id: match-id } {
      score-a: score-a,
      score-b: score-b,
      claimed: false
    })

    (ok true)
  )
)

(define-public (daily-checkin)
  (let
    (
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
      (today (/ stacks-block-height u144))
      (last-day (get last-checkin player))
      (new-streak
        (if (is-eq today (+ last-day u1))
          (+ (get streak player) u1)
          u1
        )
      )
    )
    (try! (assert-not-paused))
    (asserts! (not (is-eq today last-day)) ERR_ALREADY_CHECKED_IN)

    (map-set players tx-sender
      (merge player {
        points: (+ (get points player) u1),
        streak: new-streak,
        last-checkin: today
      })
    )

    (ok new-streak)
  )
)

(define-public (set-match-result (match-id uint) (score-a uint) (score-b uint))
  (let
    (
      (match-data (unwrap! (map-get? matches match-id) ERR_MATCH_NOT_FOUND))
    )
    (asserts! (is-admin) ERR_UNAUTHORIZED)
    (asserts! (>= stacks-block-height (get close-block match-data)) ERR_MATCH_NOT_CLOSED)
    (asserts! (<= score-a u20) ERR_INVALID_SCORE_A)
    (asserts! (<= score-b u20) ERR_INVALID_SCORE_B)

    (map-set matches match-id
      (merge match-data {
        score-a: score-a,
        score-b: score-b,
        result-set: true,
        finalized: true
      })
    )

    (ok true)
  )
)

(define-public (claim-points (match-id uint))
  (let
    (
      (match-data (unwrap! (map-get? matches match-id) ERR_MATCH_NOT_FOUND))
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
      (winner-pred (unwrap! (map-get? winner-predictions { user: tx-sender, match-id: match-id }) ERR_ALREADY_CLAIMED))
      (result-pick (get-result-pick (get score-a match-data) (get score-b match-data)))
      (winner-points
        (if (is-eq (get pick winner-pred) result-pick)
          u10
          u0
        )
      )
      (correct-inc
        (if (> winner-points u0)
          u1
          u0
        )
      )
    )
    (try! (assert-not-paused))
    (asserts! (get result-set match-data) ERR_RESULT_NOT_SET)
    (asserts! (not (get claimed winner-pred)) ERR_ALREADY_CLAIMED)

    (map-set winner-predictions { user: tx-sender, match-id: match-id }
      (merge winner-pred { claimed: true })
    )

    (map-set players tx-sender
      (merge player {
        points: (+ (get points player) winner-points),
        total-correct: (+ (get total-correct player) correct-inc)
      })
    )

    (ok winner-points)
  )
)

(define-public (claim-score-points (match-id uint))
  (let
    (
      (match-data (unwrap! (map-get? matches match-id) ERR_MATCH_NOT_FOUND))
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
      (score-pred (unwrap! (map-get? score-predictions { user: tx-sender, match-id: match-id }) ERR_ALREADY_CLAIMED))
      (score-points
        (if
          (and
            (is-eq (get score-a score-pred) (get score-a match-data))
            (is-eq (get score-b score-pred) (get score-b match-data))
          )
          u30
          u0
        )
      )
    )
    (try! (assert-not-paused))
    (asserts! (get result-set match-data) ERR_RESULT_NOT_SET)
    (asserts! (not (get claimed score-pred)) ERR_ALREADY_CLAIMED)

    (map-set score-predictions { user: tx-sender, match-id: match-id }
      (merge score-pred { claimed: true })
    )

    (map-set players tx-sender
      (merge player {
        points: (+ (get points player) score-points)
      })
    )

    (ok score-points)
  )
)

(define-public (boost-team (team-id uint) (amount uint))
  (let
    (
      (player (unwrap! (map-get? players tx-sender) ERR_NOT_JOINED))
      (current-boost (default-to u0 (map-get? team-boosts team-id)))
    )
    (try! (assert-not-paused))
    (asserts! (valid-team team-id) ERR_INVALID_TEAM)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (asserts! (>= (get points player) amount) ERR_INSUFFICIENT_POINTS)

    (map-set players tx-sender
      (merge player {
        points: (- (get points player) amount)
      })
    )

    (map-set team-boosts team-id (+ current-boost amount))
    (ok true)
  )
)
