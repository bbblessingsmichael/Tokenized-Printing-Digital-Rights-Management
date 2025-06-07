;; Publisher Verification Contract
;; Manages verification and registration of publishing companies

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_VERIFIED (err u102))

;; Data maps
(define-map verified-publishers principal bool)
(define-map publisher-details principal {
  name: (string-ascii 100),
  registration-date: uint,
  status: (string-ascii 20)
})

;; Public functions
(define-public (verify-publisher (publisher principal) (name (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? verified-publishers publisher)) ERR_ALREADY_VERIFIED)
    (map-set verified-publishers publisher true)
    (map-set publisher-details publisher {
      name: name,
      registration-date: block-height,
      status: "active"
    })
    (ok true)
  )
)

(define-public (revoke-publisher (publisher principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (default-to false (map-get? verified-publishers publisher)) ERR_NOT_VERIFIED)
    (map-set verified-publishers publisher false)
    (map-set publisher-details publisher
      (merge (unwrap-panic (map-get? publisher-details publisher)) {status: "revoked"}))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (is-verified-publisher (publisher principal))
  (default-to false (map-get? verified-publishers publisher))
)

(define-read-only (get-publisher-details (publisher principal))
  (map-get? publisher-details publisher)
)
