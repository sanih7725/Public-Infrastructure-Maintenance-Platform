;; Project NFT Contract

(define-non-fungible-token project-nft uint)

(define-map project-nft-data
  { token-id: uint }
  {
    title: (string-ascii 100),
    completion-date: uint
  }
)

(define-data-var nft-id-nonce uint u0)

(define-public (mint-project-nft (title (string-ascii 100)))
  (let
    ((new-id (+ (var-get nft-id-nonce) u1)))
    (try! (nft-mint? project-nft new-id tx-sender))
    (map-set project-nft-data
      { token-id: new-id }
      {
        title: title,
        completion-date: block-height
      }
    )
    (var-set nft-id-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-project-nft-data (token-id uint))
  (map-get? project-nft-data { token-id: token-id })
)

