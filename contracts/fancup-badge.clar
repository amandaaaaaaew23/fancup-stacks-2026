;; FanCup Stacks 2026 - Badge Contract
;; NFT badge contract for supporter cards, streak badges, and prediction badges.

(define-non-fungible-token fancup-badge uint)

(define-constant CONTRACT_OWNER tx-sender)

;; ERRORS
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_ALREADY_MINTED (err u201))
(define-constant ERR_INVALID_BADGE (err u202))
(define-constant ERR_INVALID_PRINCIPAL (err u203))

;; STATE
(define-data-var owner principal CONTRACT_OWNER)
(define-data-var last-token-id uint u0)

;; MAPS
(define-map minters principal bool)

(define-map user-badges
  { user: principal, badge-type: uint }
  bool
)

(define-map badge-metadata
  uint
  {
    badge-type: uint,
    owner: principal
  }
)

;; PRIVATE HELPERS
(define-private (is-owner)
  (is-eq tx-sender (var-get owner))
)

(define-private (is-minter)
  (or
    (is-owner)
    (default-to false (map-get? minters tx-sender))
  )
)

(define-private (mint-badge-internal (recipient principal) (badge-type uint))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-standard recipient) ERR_INVALID_PRINCIPAL)
    (asserts! (> badge-type u0) ERR_INVALID_BADGE)
    (asserts! (is-none (map-get? user-badges { user: recipient, badge-type: badge-type })) ERR_ALREADY_MINTED)

    (try! (nft-mint? fancup-badge token-id recipient))

    (var-set last-token-id token-id)

    (map-set user-badges { user: recipient, badge-type: badge-type } true)

    (map-set badge-metadata token-id {
      badge-type: badge-type,
      owner: recipient
    })

    (ok token-id)
  )
)

;; ADMIN FUNCTIONS
(define-public (set-minter (minter principal) (enabled bool))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (asserts! (is-standard minter) ERR_INVALID_PRINCIPAL)
    (map-set minters minter enabled)
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

;; MINT FUNCTIONS
;; badge-type u1-u64 = supporter card based on team-id
(define-public (mint-supporter-card (recipient principal) (team-id uint))
  (begin
    (asserts! (is-minter) ERR_UNAUTHORIZED)
    (asserts! (> team-id u0) ERR_INVALID_BADGE)
    (asserts! (<= team-id u64) ERR_INVALID_BADGE)
    (mint-badge-internal recipient team-id)
  )
)

;; badge-type u1000 = streak badge
(define-public (mint-streak-badge (recipient principal))
  (begin
    (asserts! (is-minter) ERR_UNAUTHORIZED)
    (mint-badge-internal recipient u1000)
  )
)

;; badge-type u2000 = prediction badge
(define-public (mint-prediction-badge (recipient principal))
  (begin
    (asserts! (is-minter) ERR_UNAUTHORIZED)
    (mint-badge-internal recipient u2000)
  )
)

;; READ ONLY
(define-read-only (get-contract-owner)
  (var-get owner)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

(define-read-only (get-owner (token-id uint))
  (nft-get-owner? fancup-badge token-id)
)

(define-read-only (get-badge-metadata (token-id uint))
  (map-get? badge-metadata token-id)
)

(define-read-only (has-badge (user principal) (badge-type uint))
  (default-to false (map-get? user-badges { user: user, badge-type: badge-type }))
)

(define-read-only (is-approved-minter (minter principal))
  (default-to false (map-get? minters minter))
)
