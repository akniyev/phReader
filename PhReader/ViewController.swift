//
//  ViewController.swift
//  PhReader
//
//  Created by Gasan Akniev on 09.12.2020.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let textView = TextGeometryViewer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }

    private func setUpUI() {
        setUpTextView()
    }

    private func setUpTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.margins)
        }
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.text = "Lorem ipsum dolor sit amet, eum at agam voluptatum, ut tale vulputate ius, est cu impetus legendos expetenda. Diam duis iudico sit at, eirmod commodo percipitur eam at, in rebum delicata abhorreant has. Aperiam mediocritatem nec ne, sed in vitae essent delicata, vis ea unum habeo. Ne quo tale ullum explicari. Ea reque fuisset quaerendum mel, nec copiosae reprehendunt ut. At vel hendrerit inciderint, nam ne case dissentiet theophrastus, no nec vide abhorreant.\n\nUsu ad periculis repudiare, vis maiorum democritum intellegebat at. Cu quo ancillae conceptam adipiscing, id porro aeterno appellantur mel. Te justo eripuit maiorum sea. An pro summo imperdiet, has at erat everti, pri alii mucius efficiendi ad. Lorem rationibus his an, euismod elaboraret ad sit, luptatum tacimates evertitur ne pri.\n\nEu solet eleifend urbanitas ius, unum antiopam mel id, eu sea nostro iisque. Eam ut scripta interpretaris. Debet facilisi ad per, malis cetero verterem ne est. Odio gubergren ut ius, an his mutat laudem. Mel dico principes ea, vix scripta maiorum ut. Sed ornatus comprehensam no, ea usu illud scripserit. Solum argumentum duo et.\n\nUsu ad dolorum facilisi. Duo cu mazim splendide evertitur, legendos intellegat his ei. Ponderum intellegat has no, eu constituto expetendis definiebas eum. Sea ex veri dissentiet definitionem, nemore civibus reformidans ex nec, ius nonumes signiferumque cu. Sit ei duis congue vituperatoribus.\n\nHendrerit consectetuer cu sea, semper vocibus epicuri usu no. Est in unum tantas iisque, pri minim iusto cu. Vim inani probatus cotidieque cu. Animal aperiri alterum cu est, ex per omnes alterum. Nec epicuri adipisci et, et his sonet consulatu."
    }
}

