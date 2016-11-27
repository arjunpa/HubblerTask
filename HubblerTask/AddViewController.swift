//
//  AddViewController.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController {

    @IBOutlet weak var table_view:UITableView!
    var dataSource:[RawModel] = []
    var sizingCells:Dictionary<String,TypeBaseCell> = [:]
    var usedCells:Dictionary<IndexPath,TypeBaseCell> = [:]
    var usedText:Dictionary<IndexPath, String> = [:]
    var actionSheet:GKActionSheetPicker!
    private var cancelHandler:(AddViewController) -> Void = {_ in }
    private var doneHandler:(AddViewController) -> Void = {_ in }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let manager:ParseManager = ParseManager.init()
        manager.start { (models, error) in
            print(models)
            print(error)
            
            self.dataSource = models
            self.table_view.dataSource = self
            self.table_view.delegate = self
            self.doRegistrations()
            self.table_view.reloadData()
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupNavBtns()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    class func present(_ on:UIViewController, _ doneAction:@escaping (_ addController:AddViewController) -> Void, _ cancelAction:@escaping (_ addController:AddViewController) -> Void){
        let addController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        addController.doneHandler = doneAction
        addController.cancelHandler = cancelAction
        if let navController = on.navigationController{
            navController.pushViewController(addController, animated: true)
        }
        else{
            on.present(addController, animated: true, completion: nil)
        }
    }

    func setupNavBtns(){
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 35))
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(AddViewController.doneClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setDefaultErrors(){
        for model in dataSource{
            ValidationManager.validate(rawData: model, text: "", completion: { (validation) in
                model.validation = validation
            })
        }
    }
    
    
    func doneClick(sender:UIButton){
        
        self.setDefaultErrors()
        var isValidated = true
        
      
        
        for (index,model) in dataSource.enumerated(){
            ValidationManager.validate(rawData: model, text: model.userText, completion: { (validation) in
                model.validation = validation
            })
            
            let indexPath = NSIndexPath.init(row: index, section: 0)
            if let cell = table_view.cellForRow(at: indexPath as IndexPath) as? TypeBaseCell{
                cell.model = model
                cell.setValidation()
            }
            if let _ = model.validation{
                isValidated = false
            }
        }
        
        
        if isValidated{
            print("VALIDATION COMPLETE")
            self.performPostValidationActions()
        }
        else{
            print("VALIDATION FAILED")
        }
        
        
        self.table_view.beginUpdates()
        self.table_view.endUpdates()
    }
    
    
    
    func performPostValidationActions(){
        ParseManager.getParseStr(self.dataSource, completion: { (jsonStr, error) in
            if let jsonString = jsonStr{
                print("JSON: \(jsonString)")
                UserDetails.storeRecord(self.dataSource, completion: { (status) in
                    self.postSuccessActions()
                })
            }
            else{
                print(error)
            }
            
        })
    }
    
    func postSuccessActions(){
        doneHandler(self)
        
        if let navController = self.navigationController{
            navController.popViewController(animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doRegistrations(){
        let cells = ["TypeTextCell","TypeMultiLineCell","TypePickerCell"]
        
        for cell in cells{
            let nib = UINib.init(nibName: cell, bundle: Bundle.main)
            self.table_view.register(nib, forCellReuseIdentifier: cell)
            let sizer = nib.instantiate(withOwner: self, options: nil)[0] as! TypeBaseCell
            sizingCells[cell] = sizer
            
        }
    }
    
    func resolveCell(model:RawModel) -> TypeBaseCell{
        let identifier = self.resolveIdentifier(model: model)
      
        return self.table_view.dequeueReusableCell(withIdentifier: identifier) as! TypeBaseCell
    }
    
    func resolveIdentifier(model:RawModel) -> String{
        switch model.type {
        case "multiline":
            return "TypeMultiLineCell"
        case "dropdown":
            return "TypePickerCell"
        default:
            return "TypeTextCell"
        }
    }
    
    override func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.table_view.contentInset = contentInsets
        self.table_view.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        let pointInTable = getActiveView()?.superview!.convert((self.getActiveView()?.frame.origin)!, to: table_view)
        let rectInTable = getActiveView()?.superview!.convert((self.getActiveView()?.frame)!, to: table_view)
        
        if pointInTable != nil{
            if !aRect.contains(pointInTable!) {
                self.table_view.scrollRectToVisible(rectInTable!, animated: false)
            }
        }
    }
    
    func getActiveView() -> UIView?{
        for view in self.view.subviews {
            if (view.isFirstResponder) {
                return view
            }
        }
        return nil
    }
    
    override func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.table_view.contentInset = contentInsets
        self.table_view.scrollIndicatorInsets = contentInsets
    }
    
    
}
extension AddViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rawModel = dataSource[indexPath.row]
        let cell = self.resolveCell(model: rawModel)
        
        if let multiType = cell as? TypeMultiLineCell{
            multiType.textView.delegate = self
            multiType.textView.text = rawModel.userText
        }
        else if let typeText = cell as? TypeTextCell{
            typeText.textField.delegate = self
            typeText.textField.text = rawModel.userText
        }
        else if let typePicker = cell as? TypePickerCell{
            if rawModel.userText == ""{
                typePicker.btnText.setTitle("Select", for: .normal)
            }
            else{
                typePicker.btnText.setTitle(rawModel.userText.capitalized, for: .normal)
            }
            typePicker.btnText.addTarget(self, action: #selector(AddViewController.didSelectPicker(sender:)), for: .touchUpInside)
        }
        cell.configure(model: rawModel)
        cell.selectionStyle = .none
        
        usedCells[indexPath] = cell
        return cell
    }
    
}
extension AddViewController{
    func didSelectPicker(sender:UIButton){
        let center = sender.center
        let rootViewPoint = sender.superview?.convert(center, to: self.table_view)
        let indexPath = self.table_view.indexPathForRow(at: rootViewPoint!)
        let options = dataSource[(indexPath?.row)!].options
        var gmOptionArray:[GKActionSheetPickerItem] = []
        
        for option in options{
            gmOptionArray.append(GKActionSheetPickerItem.init(title: option.capitalized, value: option))
        }
        
        self.actionSheet = GKActionSheetPicker.stringPicker(withItems: gmOptionArray, selectCallback: { (selected) in
            print("\(selected)")
                self.dataSource[(indexPath?.row)!].userText = selected as! String
            if let cell = self.table_view.cellForRow(at: indexPath!) as? TypePickerCell{
                var upcaseStr = selected as? String
                upcaseStr = upcaseStr?.capitalized
                cell.btnText.setTitle(upcaseStr, for: .normal)
            }
            
            }) {
                
        }
        actionSheet.overlayLayerColor = UIColor.clear
        actionSheet.present(on: self.view)
    }
}
extension AddViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let model = dataSource[indexPath.row]
        let identifier = self.resolveIdentifier(model: model)
        let sizingCell = sizingCells[identifier]
        sizingCell?.configure(model: model)
        let target = CGSize.init(width: UIScreen.main.bounds.width, height: 0.5 * UIScreen.main.bounds.width)
  
        if let celld = sizingCell as? TypeMultiLineCell{
            if let _ = usedCells[indexPath] as?  TypeMultiLineCell{
                
                celld.fieldLabel.text = model.field_name.capitalized
                celld.textView.text = model.userText
                celld.errorLabel.text = model.validation?.message
            }
        }
        else if let celld = sizingCell as? TypeTextCell{
            
            if let _ = usedCells[indexPath] as? TypeTextCell{
                celld.fieldLabel.text = model.field_name.capitalized
                celld.textField.text = model.userText
                celld.errorLabel.text = model.validation?.message
            }
        }
        else if let celld = sizingCell as? TypePickerCell{
            if let _ = usedCells[indexPath] as? TypePickerCell{
                celld.fieldLabel.text = model.field_name.capitalized
                celld.errorLabel.text = model.validation?.message
                
                if model.userText == ""{
                     celld.btnText.setTitle("Select", for: .normal)
                }
                else{
                    celld.btnText.setTitle(model.userText, for: .normal)
                }
            }
        }
        
        let height = (sizingCell?.preferredSizeFittingTargetSize(targetSize: target))?.height
        if identifier == "TypeMultiLineCell"{
            let celld = sizingCell as! TypeMultiLineCell
            print("text: \(celld.textView.text)")
            print("HEIGHT: \(height)")
        }
        
        return height!
    }
}
extension AddViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.table_view.beginUpdates()
        self.table_view.endUpdates()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.table_view.beginUpdates()
        self.table_view.endUpdates()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        
        
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
    
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        
  /*      if text == ""{
            if (textd?.characters.count)! > 0{
                let endIndex = textd?.endIndex
                textd!.remove(at: (textd?.index(before: endIndex!))!)
            }
        }
        else{
            textd = textd! + text
        }
 */
        var textd:NSString = textView.text! as NSString
        textd = textd.replacingCharacters(in: range, with: text) as NSString
        
        print(textd)
        
        let center = textView.center
        let rootViewPoint = textView.superview?.convert(center, to: self.table_view)
        let indexPath = self.table_view.indexPathForRow(at: rootViewPoint!)
        dataSource[(indexPath?.row)!].userText = textd as String
        usedText[indexPath!] = textd as String
        return true
    }
}
extension AddViewController:UITextFieldDelegate{
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
  
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
   
        return true
 
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       /* var text = textField.text
        
        if string == ""{
            if (text?.characters.count)! > 0{
                let endIndex = text?.endIndex
                text?.remove(at: (text?.index(before: endIndex!))!)
            }
        }
        else{
            text = text! + string
        }
 */
        
        var text:NSString = textField.text! as NSString
        text = text.replacingCharacters(in: range, with: string) as NSString
        print(text)
        let center = textField.center
        let rootViewPoint = textField.superview?.convert(center, to: self.table_view)
        let indexPath = self.table_view.indexPathForRow(at: rootViewPoint!)
        dataSource[(indexPath?.row)!].userText = text as String
        usedText[indexPath!] = text as String
 
        return true
    }
}


