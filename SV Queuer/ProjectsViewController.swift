import UIKit

class ProjectsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var projects: [ProjectModel]?
    var selectedProject: ProjectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        fetchProjects()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let projectViewController = segue.destination as? ProjectViewController {
            projectViewController.project = selectedProject
        }
    }
}

// Mark: Actions
private extension ProjectsViewController {
    @objc func promptCreateProject() {
        let creatProjectPrompt = UIAlertController(title: StringConstants.creatProjectPromptTitle, message: nil, preferredStyle: .alert)
        let addProjectAction = UIAlertAction(title: StringConstants.okActionTitle, style: .default) { [weak self] _ in
            let name = creatProjectPrompt.textFields?.first?.text
            
            self?.addProject(name: name)
        }
        
        let cancelAction = UIAlertAction(title: StringConstants.cancelActionTitle, style: .cancel, handler: { (action) in
            creatProjectPrompt.dismiss(animated: true, completion: nil)
        })
        
        creatProjectPrompt.addAction(addProjectAction)
        creatProjectPrompt.addAction(cancelAction)
        creatProjectPrompt.addTextField { textfield in
            textfield.placeholder = StringConstants.namePlaceholder
        }
        
        present(creatProjectPrompt, animated: true, completion: nil)
    }
}

// Mark: Utility + Networking functions
private extension ProjectsViewController {
    func configure() {
        title = StringConstants.projectsTitle
        tableView.dataSource = self
        tableView.delegate = self

        navigationController?.navigationBar.barTintColor = UIColor.navigationTeal
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProjectsViewController.promptCreateProject))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func fetchProjects() {
        let request = HerokuRequest(path: "projects", httpMethod: HttpMethod.get)
        HerokuService.send(with: request, responseType: [ProjectModel].self, onSuccess: { [weak self] response, urlResponse in
            if let response = response as? [ProjectModel] {
                self?.projects = response
                
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
    
    func addProject(name: String?) {
        let requestBody = ProjectModel(name: name, color: NumberConstants.defaultProjectColor)
        let request = HerokuRequest(path: "projects", httpBody: requestBody, httpMethod: HttpMethod.post)
        
        HerokuService.send(with: request, responseType: ProjectModel.self, onSuccess: { [weak self] response, urlResponse in
            self?.fetchProjects()
        }, onFail: { [weak self] requestError in
            DispatchQueue.main.async {
                let errorAlert = UIAlertController.errorAlert(with: requestError, completion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        })
    }
}

// Mark: UITableViewDataSource
extension ProjectsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = projects?[indexPath.row].name ?? ""
        return cell
    }
}

// Mark: UITableViewDelegate
extension ProjectsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projects?[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewproject", sender: self)
    }
}
