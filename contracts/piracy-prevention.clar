;; Piracy Prevention Contract
;; Monitors and prevents unauthorized printing

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_SUSPICIOUS_ACTIVITY (err u501))
(define-constant ERR_ACCOUNT_FLAGGED (err u502))

;; Data structures
(define-map flagged-accounts principal {
  reason: (string-ascii 200),
  flagged-at: uint,
  active: bool
})

(define-map print-monitoring principal {
  total-prints: uint,
  last-print-time: uint,
  suspicious-count: uint
})

(define-map violation-reports uint {
  reporter: principal,
  violator: principal,
  content-id: uint,
  description: (string-ascii 500),
  timestamp: uint,
  status: (string-ascii 20)
})

(define-data-var next-report-id uint u1)
(define-constant PRINT_CONTRACT .print-authorization)

;; Public functions
(define-public (report-violation
  (violator principal)
  (content-id uint)
  (description (string-ascii 500)))
  (let ((report-id (var-get next-report-id)))
    (map-set violation-reports report-id {
      reporter: tx-sender,
      violator: violator,
      content-id: content-id,
      description: description,
      timestamp: block-height,
      status: "pending"
    })
    (var-set next-report-id (+ report-id u1))
    (ok report-id)
  )
)

(define-public (flag-account (account principal) (reason (string-ascii 200)))
  (begin
    ;; In real implementation, would check if tx-sender is authorized moderator
    (map-set flagged-accounts account {
      reason: reason,
      flagged-at: block-height,
      active: true
    })
    (ok true)
  )
)

(define-public (monitor-print-activity (printer principal) (copies uint))
  (let (
    (current-monitoring (default-to {total-prints: u0, last-print-time: u0, suspicious-count: u0}
                        (map-get? print-monitoring printer)))
    (new-total (+ (get total-prints current-monitoring) copies))
    (time-diff (- block-height (get last-print-time current-monitoring)))
  )
    ;; Check for suspicious activity (more than 100 prints in 10 blocks)
    (if (and (> copies u100) (< time-diff u10))
      (begin
        (map-set print-monitoring printer {
          total-prints: new-total,
          last-print-time: block-height,
          suspicious-count: (+ (get suspicious-count current-monitoring) u1)
        })
        (if (> (get suspicious-count current-monitoring) u3)
          (map-set flagged-accounts printer {
            reason: "Excessive printing activity detected",
            flagged-at: block-height,
            active: true
          })
          true
        )
        (ok true)
      )
      (begin
        (map-set print-monitoring printer {
          total-prints: new-total,
          last-print-time: block-height,
          suspicious-count: (get suspicious-count current-monitoring)
        })
        (ok true)
      )
    )
  )
)

;; Read-only functions
(define-read-only (is-account-flagged (account principal))
  (match (map-get? flagged-accounts account)
    flag (get active flag)
    false
  )
)

(define-read-only (get-violation-report (report-id uint))
  (map-get? violation-reports report-id)
)

(define-read-only (get-print-monitoring (account principal))
  (map-get? print-monitoring account)
)
