//
//  ConsolePrintViewController.swift
//  MagiEye
//
//  Created by anran on 2019/3/15.
//  Copyright © 2019 anran. All rights reserved.
//

import Foundation

class ConsolePrintViewController: UIViewController {
    
    
    private lazy var recordTableView: RecordTableView = { [unowned self] in
        let new = RecordTableView()
        new.delegate = self.dataSource
        new.dataSource = self.dataSource
        
        return new
        }()
    
    private lazy var inputField: UITextField = { [unowned self] in
        let new = UITextField(frame: CGRect.zero)
        new.borderStyle = .roundedRect
        new.font = UIFont.courier(with: 12)
        new.autocapitalizationType = .none
        new.autocorrectionType = .no
        new.returnKeyType = .done
        new.enablesReturnKeyAutomatically = false
        new.clearButtonMode = .whileEditing
        new.contentVerticalAlignment = .center
        new.placeholder = "Enter command..."
        new.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        new.delegate = self
        return new
        }()
    
    private var dataSource: RecordTableViewDataSource!
    fileprivate var originRect: CGRect = CGRect.zero
    private var type: RecordType
    
    init(type: RecordType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        dataSource = RecordTableViewDataSource(type: type)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        edgesForExtendedLayout = []
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = UIColor.niceBlack()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: self,
                action: #selector(handleDeleteButtonTap)),
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(handleSharedButtonTap))
        ]
        
        view.addSubview(recordTableView)
        view.addSubview(inputField)
        recordTableView.magiRefresh.bindStyleForHeaderRefresh(
            themeColor: UIColor.orange,
            refreshStyle: .replicatorTriangle) {
                [weak self] in
                let result = self?.dataSource.loadPrePage()
                if result == true {
                    self?.recordTableView.reloadData()
                }
                self?.recordTableView.magiRefresh.header?.endRefreshing()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(noti:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(noti:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let rect = view.bounds
        if type == .command {
            let height: CGFloat = 28.0
            var rect = view.bounds
            rect.origin.x = 5
            rect.origin.y = rect.size.height - height - 5
            rect.size.width -= rect.origin.x * 2
            rect.size.height = height
            inputField.frame = rect
            
            recordTableView.frame = CGRect(x: 0, y: 0,
                                           width: view.frame.size.width,
                                           height: inputField.frame.minY)
        }else {
            recordTableView.frame = rect
            inputField.frame = CGRect.zero
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        recordTableView.smoothReloadData(need: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recordTableView.scrollToBottom(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func addRecord(model:RecordORMProtocol) {
        
        self.dataSource.addRecord(model: model)
        
        if self.view.superview != nil {
            self.recordTableView.smoothReloadData(need: false)
        }
    }
    
    @objc private func handleSharedButtonTap() {
        
        let image = self.recordTableView.swContentCapture { [unowned self] (image: UIImage?) in
            
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            if let popover = activity.popoverPresentationController {
                popover.sourceView = self.view
                popover.permittedArrowDirections = .up
            }
            self.present(activity, animated: true, completion: nil)
        }
    }
    
    @objc private func handleDeleteButtonTap() {
        self.type.model()?.delete(complete: { [unowned self] (finish:Bool) in
            self.dataSource.cleanRecord()
            self.recordTableView.reloadData()
        })
    }
 
}


extension ConsolePrintViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        guard text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" else {
            return
        }
        
        MagiEyeController.shared
            .configuration?
            .command
            .execute(command: text) { [unowned self] (model:CommandRecordModel) in
                
                model.insert(complete: { (true:Bool) in
                    self.addRecord(model: model)
                })
        }
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc
    fileprivate func keyboardWillShow(noti: Notification) {
        guard let userInfo = noti.userInfo else {
            return
        }
        
        guard let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve.RawValue else {
            return
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
        
        var bounds = self.view.frame
        self.originRect = bounds
        switch UIApplication.shared.statusBarOrientation {
            
        case .portraitUpsideDown:
            bounds.origin.y += frame.size.height
            bounds.size.height -= frame.size.height
            
        case .landscapeLeft:
            bounds.size.width -= frame.size.width
            
        case .landscapeRight:
            bounds.origin.x += frame.size.width
            bounds.size.width -= frame.size.width
            
        default:
            bounds.size.height -= frame.size.height
        }
        self.view.frame = bounds
        
        UIView.commitAnimations()
    }
    
    @objc
    fileprivate func keyboardWillHide(noti: NSNotification) {
        guard let userInfo = noti.userInfo else {
            return
        }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve.RawValue else {
            return
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
        self.view.frame = self.originRect
        UIView.commitAnimations()
    }
}
