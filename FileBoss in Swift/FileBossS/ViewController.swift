//
//  ViewController.swift
//  FileBossS
//
//  Created by david on 1/13/21.
//

import UIKit

extension String {
  var ns: NSString { self as NSString }
  var pathExtension: String { ns.pathExtension }
  func appendingPathComponent(_ s:String) -> String { ns.appendingPathComponent(s) }
}

class ViewController: UITableViewController, UIDocumentInteractionControllerDelegate {

  var files: Array<String> = []
  var interactionIndex: Int = 0
  var interactor : UIDocumentInteractionController?
  lazy var documentsPath: String = {
    NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("File Boss", comment: "")
    tableView.tableHeaderView = constructHeader();
    loadFiles()
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  /// resize the tableview header so all the lines of text are visible.
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if let header = tableView.tableHeaderView, let label = header.subviews.first {
      var frame = header.frame
      frame.size.height = label.sizeThatFits(frame.insetBy(dx: 20, dy: 0).size).height
      header.frame = frame
    }
  }

// MARK: -

  func constructHeader() -> UIView {
    var r = UIScreen.main.bounds
    r.size.height = 40
    let header = UIView(frame: r)
    header.backgroundColor = UIColor.secondarySystemFill;
    r = r.insetBy(dx: 20, dy: 0)
    let textLabel = UILabel(frame: r)
    header.addSubview(textLabel)
    textLabel.numberOfLines = 0
    textLabel.text = NSLocalizedString("Directions", comment: "")
    textLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.2, alpha: 1)
    textLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleBottomMargin]
    return header
  }

  @objc
  func didBecomeActive(_ note : Notification){
    loadFiles()
  }
  
	func loadFiles() {
    let fm = FileManager.default
    do {
      print("\(documentsPath)")
      let dirFiles = try fm.contentsOfDirectory(atPath: documentsPath)
      var files1: [String] = []
      for file: String in dirFiles {
        if !file.pathExtension.isEmpty {
          files1.append(file)
        }
      }
      files1.sort()
      if files != files1 {
        self.files = files1
        tableView.reloadData()
      }
    } catch {
    }
  }

  func deleteFileAtTableIndex(_ row: Int) {
    let filePath = documentsPath.appendingPathComponent(files[row])
    do {
      try FileManager.default.removeItem(atPath: filePath)
      files.remove(at: row)
      tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    } catch {
    }
  }

  func shareFileAtTableIndex(_ row: Int) {
    let fileURL = URL(fileURLWithPath: documentsPath.appendingPathComponent(files[row]))
    interactor = UIDocumentInteractionController(url: fileURL)
    if let interactor = interactor {
      interactor.delegate = self
      if let itemRect = tableView.cellForRow(at: IndexPath(row: row, section: 0))?.frame {
        interactionIndex = row
        if !interactor.presentOpenInMenu(from: itemRect, in: tableView, animated: true) {
          // maybe let the user know that no app on the iPhone likes thid file extension.
        }
      }
    }
  }

// MARK: -

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return files.count
  }
  
  func configureCell(_ cell: UITableViewCell, index: Int) -> UITableViewCell {
    cell.textLabel?.text = files[index]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "a") {
      return configureCell(cell, index: indexPath.row)
    } else {
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "a")
      return configureCell(cell, index: indexPath.row)
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    shareFileAtTableIndex(indexPath.row)
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteFileAtTableIndex(indexPath.row)
    }
  }

// MARK: -

  func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
    interactor = nil
  }

  func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
    if application != nil && interactionIndex != NSNotFound {
      // maybe remove the file on successful transfer to another app.
    }
  }

}

