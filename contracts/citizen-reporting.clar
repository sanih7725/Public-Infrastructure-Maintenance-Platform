;; Citizen Reporting Contract

(define-map reports
  { report-id: uint }
  {
    reporter: principal,
    project-id: uint,
    description: (string-utf8 500),
    status: (string-ascii 20),
    timestamp: uint
  }
)

(define-data-var report-nonce uint u0)

(define-public (submit-report (project-id uint) (description (string-utf8 500)))
  (let
    ((new-id (+ (var-get report-nonce) u1)))
    (map-set reports
      { report-id: new-id }
      {
        reporter: tx-sender,
        project-id: project-id,
        description: description,
        status: "submitted",
        timestamp: block-height
      }
    )
    (var-set report-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-report-status (report-id uint) (new-status (string-ascii 20)))
  (let
    ((report (unwrap! (map-get? reports { report-id: report-id }) (err u404))))
    (asserts! (is-eq tx-sender (get reporter report)) (err u403))
    (map-set reports
      { report-id: report-id }
      (merge report { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-report (report-id uint))
  (map-get? reports { report-id: report-id })
)

