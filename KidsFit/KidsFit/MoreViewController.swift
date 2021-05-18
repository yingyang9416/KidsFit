//
//  MoreViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 3/25/21.
//

import UIKit
import SPAlert

class MoreViewController: UIViewController {

    @IBOutlet weak var moreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.tintColor = .white
    }
    
    let settings: [[SettingsCellStruct]] =
        [[SettingsCellStruct(iconImage: UIImage.profile, title: "My profile"),
          SettingsCellStruct(iconImage: UIImage.gym, title: "My primary gym")],
         [SettingsCellStruct(iconImage: UIImage.edit, title: "Edit WOD")],
         [SettingsCellStruct(iconImage: UIImage.video, title: "Workout videos")],
         [SettingsCellStruct(iconImage: UIImage.instagram, title: "Instagram"),
          SettingsCellStruct(iconImage: UIImage.youtube, title: "Youtube")],
         [SettingsCellStruct(iconImage: UIImage.changePassword, title: "Change password"),
          SettingsCellStruct(iconImage: UIImage.logout, title: "Sign out")]]
    
    func setupTableView() {
        moreTableView.register(cell: MoreTableViewCell.self)
        moreTableView.backgroundColor = .systemGray6
        moreTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func logoutUser() {
        if FirebaseAuth.shared.logoutUser() {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate = scene?.delegate as? SceneDelegate {
                sceneDelegate.rout()
            }
        } else {
            SPAlert.present(message: "Something went wrong", haptic: .error)
        }
    }
    
    func sendPasswordReset() {
        guard let email = UserDefaults.currentUser()?.email else { return }
        
        FirebaseAuth.shared.sendPasswordReset(email: email) {
            SPAlert.present(title: "A password reset link was sent to your email", preset: .done)
        } onFailure: { (error) in
            SPAlert.present(message: error.localizedDescription, haptic: .error)
        }

    }

}

extension MoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: MoreTableViewCell.self, indexPath: indexPath)
        cell.bind(setting: settings[indexPath.section][indexPath.row])
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            cell.type = .primaryGym
        case (4, 1):
            cell.type = .signout
        default:
            cell.type = .regular
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(storyboard: .Main)
                let myInfoVC = storyboard.instantiateViewController(withIdentifier: MyInfoViewController.self)
                navigationController?.pushViewController(myInfoVC, animated: true)
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(storyboard: .Main)
                let wodVC = storyboard.instantiateViewController(withIdentifier: EditWODViewController.self)
                navigationController?.pushViewController(wodVC, animated: true)
            default:
                return
            }
        case 2:
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(storyboard: .Main)
                let videoVC = storyboard.instantiateViewController(withIdentifier: WorkoutVideosViewController.self)
                navigationController?.pushViewController(videoVC, animated: true)
            default:
                return
            }

        case 3:
            switch indexPath.row {
            case 0:  // instagram
                if let url = URL(string: "https://instagram.com/carterparkcrossfit") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 1:  // youtube
                if let url = URL(string: "https://youtube.com") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            default:
                return
            }
        case 4:
            switch indexPath.row {
            case 0: // Reset password
                let alert = UIAlertController(title: "Reset password", message: "We will send you an email to reset password. Do you want to proceed?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default) { (_) in
                    self.sendPasswordReset()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            case 1:  // Log out
                logoutUser()
            default:
                return
            }
        default:
            return
        }
    }
    
}
