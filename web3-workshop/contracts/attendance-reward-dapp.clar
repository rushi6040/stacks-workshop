;; Define the fungible token
(define-fungible-token simple-token) ;; or include max supply if desired

;; Stake state
(define-map stakes principal uint)
(define-data-var total-staked uint u0)

;; Stake function
(define-public (stake (amount uint))
  (begin
    (asserts! (> amount u0) (err u101))
    (try! (ft-transfer? simple-token amount tx-sender (as-contract tx-sender)))
    (map-set stakes tx-sender (+ (default-to u0 (map-get? stakes tx-sender)) amount))
    (var-set total-staked (+ (var-get total-staked) amount))
    (ok true)))

;; Unstake function
(define-public (unstake (amount uint))
  (begin
    (asserts! (> amount u0) (err u102))
    (let ((current (default-to u0 (map-get? stakes tx-sender))))
      (asserts! (>= current amount) (err u103))
      (map-set stakes tx-sender (- current amount))
      (var-set total-staked (- (var-get total-staked) amount))
      (try! (ft-transfer? simple-token amount (as-contract tx-sender) tx-sender))
      (ok true))))
