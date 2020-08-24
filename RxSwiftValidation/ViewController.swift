//
//  ViewController.swift
//  RxSwiftValidation
//
//  Created by StarbazZ on 24/8/2563 BE.
//  Copyright © 2563 StarbazZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignin: UIButton!
    
    
    private let loginViewModel = LoginViewModel()
    private let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        txtUsername.rx.text.map { $0 ?? ""
        }.bind(to: loginViewModel.strUsername).disposed(by: disposBag)
        txtPassword.rx.text.map { $0 ?? ""
        }.bind(to: loginViewModel.strPassword).disposed(by: disposBag)
        
        loginViewModel.isValidate().bind(to: btnSignin.rx.isEnabled).disposed(by: disposBag)
        loginViewModel.isValidate().map { $0 ? 1: 0.1
        }.bind(to: btnSignin.rx.alpha).disposed(by: disposBag)
    }

    @IBAction func clickSignin(_ sender: Any) {
        print("clickSignin")
    }
}

class LoginViewModel {
    let strUsername = PublishSubject<String>()
    let strPassword = PublishSubject<String>()
    
    func isValidate()-> Observable<Bool> {
        return Observable.combineLatest(strUsername.asObserver().startWith(""), strPassword.asObserver().startWith("")).map { (user, pass) in
            return user.count > 6 && pass.count > 6
        }.startWith(false)
    }
}
