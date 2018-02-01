import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    var project: ProjectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        // This call assumes we need extra projec
        // info from the previous controller
        fetchProjectInfo()
    }
}

// Mark: Actions
private extension ProjectViewController {
    @objc func creatTask() {
        let createTaskAlert = UIAlertController(title: StringConstants.createTaskPromptTitle, message: nil, preferredStyle: .alert)
        let addTaskAction = UIAlertAction(title: StringConstants.okActionTitle, style: .default) { [weak self] _ in
            let taskName = createTaskAlert.textFields?.first?.text
            let newTask = TaskModel(name: taskName)
            
            if let id = self?.project?.id {
                self?.addTask(for: id, task: newTask)
            }
        }
        
        let cancelAction = UIAlertAction(title: StringConstants.cancelActionTitle, style: .cancel, handler: { (action) in
            createTaskAlert.dismiss(animated: true, completion: nil)
        })
        
        createTaskAlert.addAction(addTaskAction)
        createTaskAlert.addAction(cancelAction)
        createTaskAlert.addTextField { textfield in
            textfield.placeholder = StringConstants.namePlaceholder
        }
        
        present(createTaskAlert, animated: true, completion: nil)
    }
}

// Mark: Utility + Networking Functions
private extension ProjectViewController {
    func configure() {
        title = StringConstants.tasksTitle
        tableView.dataSource = self
        tableView.delegate = self
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProjectViewController.creatTask))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func fetchProjectInfo() {
        guard let id = project?.id else {
            return
        }
        
        let projectId = String(describing: id)
        let request = HerokuRequest(path: "projects/\(projectId)", httpMethod: HttpMethod.get)
        
        HerokuService.send(with: request, responseType: ProjectModel.self, onSuccess: { [weak self] project, urlResponse in
            if let project = project as? ProjectModel {
                self?.project = project
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }) { [weak self] requestError in
            DispatchQueue.main.async {
                let errorAlert = UIAlertController.errorAlert(with: requestError, completion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    func addTask(for id: Int, task: TaskModel) {
        let projectId = String(describing: id)
        let request = HerokuRequest(path: "projects/\(projectId)/tasks", httpBody: task, httpMethod: HttpMethod.post)
        
        HerokuService.send(with: request, responseType: TaskModel.self, onSuccess: { [weak self] _, _ in
            self?.fetchProjectInfo()
        }) { [weak self] requestError in
            DispatchQueue.main.async {
                let errorAlert = UIAlertController.errorAlert(with: requestError, completion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}

// Mark: UITableViewDataSource
extension ProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "task") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = project?.tasks?[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project?.tasks?.count ?? 0
    }
}
