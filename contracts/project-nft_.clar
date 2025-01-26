;; Project NFT Contract

(define-non-fungible-token project-nft uint)

(define-map project-nft-data
  { token-id: uint }
  {
    project-id: uint,
    title: (string-ascii 100),
    completion-date: uint
  }
)

(define-public (mint-project-nft (project-id uint))
  (let
    ((project (unwrap! (contract-call? .project-management get-project project-id) (err u404))))
    (asserts! (is-eq (get status project) "completed") (err u403))
    (try! (nft-mint? project-nft project-id tx-sender))
    (map-set project-nft-data
      { token-id: project-id }
      {
        project-id: project-id,
        title: (get title project),
        completion-date: block-height
      }
    )
    (ok true)
  )
)

(define-read-only (get-project-nft-data (token-id uint))
  (map-get? project-nft-data { token-id: token-id })
)

