//
//  ViewController.swift
//  testForPryaniky
//
//  Created by adeleLover on 18.06.2021.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var data = [dataFromJson]()
    var viewArray = [String]()
    var button: UIButton?
    var buttonUpdate: UIButton?
    var collectionView: UICollectionView?
    var idSelectedCell = 0
    var idSelectedPicker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet() {
            setupCollectionView()
            setupViewController()
            loadData()
        } else {
            setupNoInternetViewController()
        }
    }
    
    func loadData(){
        AF.request("https://pryaniky.com/static/json/sample.json").responseJSON(completionHandler: { (response) in
            let dataJSON = JSON(response.value!)
            let data = dataJSON["data"].arrayValue
            for item in data{
                let tempData = dataFromJson(json: item)
                self.data.append(tempData)
            }
            let view = dataJSON["view"].arrayValue
            for item in view{
                let tempView = item.string
                self.viewArray.append(tempView!)
            }
            self.collectionView?.reloadData()
        })
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 140, width: view.bounds.width, height: view.bounds.height-210), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.allowsSelection = true
        collectionView?.backgroundColor = .white
        collectionView?.register(UINib(nibName: "HZCell", bundle: nil), forCellWithReuseIdentifier: "HZCellID")
        collectionView?.register(UINib(nibName: "PictureCell", bundle: nil), forCellWithReuseIdentifier: "PictureCellID")
        collectionView?.register(UINib(nibName: "SelectorCell", bundle: nil), forCellWithReuseIdentifier: "SelectorCellID")
        view.addSubview(collectionView!)
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setupNoInternetViewController(){
        view.backgroundColor = .red
        let title = UILabel(frame: CGRect(x: 20, y: view.bounds.height/2, width: view.bounds.width-20, height: 70))
        title.text = "Нет интернет-соединения"
        title.numberOfLines = 0
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.view.addSubview(title)
        buttonUpdate = UIButton(frame: CGRect(x: 20, y: view.bounds.height-70, width: view.bounds.width-40, height: 50))
        buttonUpdate?.backgroundColor = #colorLiteral(red: 0.2392938435, green: 0.6638772488, blue: 0.9710217118, alpha: 1)
        buttonUpdate?.isEnabled = true
        buttonUpdate?.alpha = 1
        buttonUpdate?.setTitle("Обновить", for: .normal)
        buttonUpdate?.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        self.view.addSubview(buttonUpdate!)
        
    }
    
    fileprivate func setupViewController() {
        view.backgroundColor = .white
        button = UIButton(frame: CGRect(x: 20, y: view.bounds.height-70, width: view.bounds.width-40, height: 50))
        button?.backgroundColor = #colorLiteral(red: 0.2392938435, green: 0.6638772488, blue: 0.9710217118, alpha: 1)
        button?.isEnabled = false
        button?.alpha = 0.5
        button?.setTitle("Результат", for: .normal)
        button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button?.layer.cornerRadius = 5
        self.view.addSubview(button!)
        let title = UILabel(frame: CGRect(x: 20, y: 70, width: view.bounds.width-40, height: 75))
        title.text = "PryanikyTest"
        title.numberOfLines = 0
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.view.addSubview(title)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewArray[indexPath.row] {
        case "hz":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HZCellID", for: indexPath) as! HZCell
            cell.layer.cornerRadius = 7
            cell.textLabel.text = searchNeedData(name: "hz")!.data.text
            return cell
        case "picture":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCellID", for: indexPath) as! PictureCell
            cell.layer.cornerRadius = 7
            let url = URL(string: searchNeedData(name: "picture")!.data.url!)
            cell.Image.kf.setImage(with: url)
            cell.textLabel.text = searchNeedData(name: "picture")!.data.text
            return cell
        case "selector":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectorCellID", for: indexPath) as! SelectorCell
            cell.layer.cornerRadius = 7
            cell.selectorPicker.dataSource = self
            cell.selectorPicker.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HZCellID", for: indexPath) as! HZCell
            cell.textLabel.text = "this is problem"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewArray[indexPath.row] {
        case "hz":
            return CGSize(width: Int(view.bounds.width)-40, height: 70)
        case "picture":
            return CGSize(width: Int(view.bounds.width)-40, height: 340)
        case "selector":
            return CGSize(width: Int(view.bounds.width)-40, height: 160)
        default:
            return CGSize(width: Int(view.bounds.width)-40, height: 160)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: IndexPath.init(row: idSelectedCell, section: 0))?.isSelected = false
        collectionView.cellForItem(at: indexPath)?.isSelected = true
        idSelectedCell = indexPath.row
        button?.isEnabled = true
        button?.alpha = 1
    }
    
    
    func searchNeedData(name:String) -> dataFromJson?{
        for element in data {
            if element.name == name{
                return element
            }
        }
        return nil
    }
    @objc func updateButtonAction(sender: UIButton!) {
        buttonUpdate?.isHidden = true
        viewDidLoad()
    }
    @objc func buttonAction(sender: UIButton!) {
        let alertVC = UIAlertController(
            title: "Выбран объект",
            message: "Имя объекта: \(viewArray[idSelectedCell])",
            preferredStyle: .alert)
        if (viewArray[idSelectedCell] == "selector"){
            alertVC.message! += " id: \(idSelectedPicker)"
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
extension ViewController: UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchNeedData(name: "selector")!.data.variants!.count
    }
}
extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        collectionView(collectionView!, didSelectItemAt: IndexPath.init(row: viewArray.firstIndex(of: "selector")!, section: 0))
        button?.isEnabled = true
        button?.alpha = 1
        idSelectedPicker = searchNeedData(name: "selector")!.data.variants![row].id
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchNeedData(name: "selector")!.data.variants![row].text
    }
}
