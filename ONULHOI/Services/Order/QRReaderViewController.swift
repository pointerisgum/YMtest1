//
//  QRReaderViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/17.
//

import UIKit
import MercariQRScanner

extension QRReaderViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Order", bundle: nil)
}

class QRReaderViewController: UMBaseViewController {

    @IBOutlet weak var scanner: QRScannerView!
    @IBOutlet weak var v_StatusBg: UIBView!
    @IBOutlet weak var lb_Status: UILabel!
    
    var completeHandler: ((String) -> Void)? = { _ in }
    var code: String?
    var count: Int = 0
    var dcId: Int?
    var orgDate: Date!
    var items: [NDOrder.InboundAtOperationInventoryQuantityWithSkuMap]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalCnt = items?.compactMap({ $0.purchaseQuantity ?? 0 }).reduce(0) { $0 + $1 }
        let scanCnt = items?.compactMap({ $0.currentScannedQuantity ?? 0 }).reduce(0) { $0 + $1 }
        count = (totalCnt ?? 0) - (scanCnt ?? 0)
        
        scanner.configure(delegate: self)
        scanner.startRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scanner.session.isRunning == false {
            scanner.configure(delegate: self)
            scanner.startRunning()
            v_StatusBg.backgroundColor = UIColor.black
            lb_Status.text = "화면에 잘 들어오도록 스캔해주세요"
        }
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        scanner.stopRunning()
//    }
    
    func sendScanData(code: String) {
        var sender = MRest.Sender(path: .scanning)
        sender.parameters[Keys.receiptDate] = orgDate.string(fmt: "yyyy-MM-dd")
        sender.parameters[Keys.dcId] = dcId
        sender.parameters[Keys.skuCode] = code
        //5qYkDFS2
        
        MRest.shared.request(sender) { (resp: MRest.Resp<NARow<NDScan>>) in
            guard resp.code == .success else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    var actions: [UMAction] = []
                    actions.append(UMAction(title: HSTR("comm.confirm"), style: .confirm, handler: {
                        self.scanner.configure(delegate: self)
                        self.scanner.startRunning()
                        self.v_StatusBg.backgroundColor = UIColor.black
                        self.lb_Status.text = "화면에 잘 들어오도록 스캔해주세요"
                    }))
                    PPAlert.present(inVC: self, title: resp.message, actions: actions)
                }
                return
            }

            guard let item = resp.object.row else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true)
//                self.completeHandler?(code)
            }
        }
    }

    @IBAction override func goDismiss(_ sender: Any?) {
        scanner.stopRunning()

        if count > 0 {
            var actions: [UMAction] = []
            actions.append(UMAction(title: HSTR("comm.yes"), style: .confirm, handler: {
                self.dismiss(animated: true)
            }))
            actions.append(UMAction(title: HSTR("comm.no"), style: .cancel, handler: {
                self.scanner.startRunning()
            }))
            
            let msg = "출고수량이 \(count)개 모자랍니다.\n그래도 나가시겠습니까?"
            PPAlert.present(inVC: self, title: HSTR("스캔이 완료되지 않았습니다."), message: msg, actions: actions)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func goScanList(_ sender: Any) {
        scanner.stopRunning()

        let vc = OrderDetailViewController.instantiate()
        vc.mode = .scan
        vc.dcId = dcId
        vc.orgDate = orgDate
        vc.isModal = true
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)

//        let vc = OrderDetailViewController.instantiate()
//        vc.mode = .scan
//        vc.dcId = dcId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension QRReaderViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        v_StatusBg.backgroundColor = UIColor.color_ff1919
        lb_Status.text = "스캔 실패! 다시 시도해주세요"
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        self.code = code
        
        scanner.stopRunning()

        v_StatusBg.backgroundColor = UIColor.color_18a0fb
        lb_Status.text = "스캔 성공!"
        sendScanData(code: code)
    }
}
