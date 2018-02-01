//
//  ProjectModel.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/30/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

struct ProjectModel: Codable {
    let id: Int?
    let name: String?
    let color: Int?
    let timeCreated: String?
    let timeUpdated: String?
    let tasks: [TaskModel]?
    let points: Int?
    let remainingPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case timeCreated = "created_at"
        case timeUpdated = "updated_at"
        case remainingPoints = "remaining_points"
        
        case id
        case name
        case color
        case tasks
        case points
    }
    
    init(id: Int? = nil, name: String? = nil, color: Int? = nil, timeCreated: String? = nil, timeUpdated: String? = nil, tasks: [TaskModel]? = nil, points: Int? = nil, remainingPoints: Int? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.timeCreated = timeCreated
        self.timeUpdated = timeUpdated
        self.tasks = tasks
        self.points = points
        self.remainingPoints = remainingPoints
    }
    
    // Used so that we can encode a project with all params
    // to send in a post request
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeCreated, forKey: .timeCreated)
        try container.encode(timeUpdated, forKey: .timeUpdated)
        try container.encode(remainingPoints, forKey: .remainingPoints)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(tasks, forKey: .tasks)
        try container.encode(points, forKey: .points)
    }
}

struct TaskModel: Codable {
    let id: Int?
    let name: String?
    let order: String?
    let finished: Bool?
    let timeCreated: String?
    let timeUpdated: String?
    let projectId: Int?
    let points: Int?
    
    enum CodingKeys: String, CodingKey {
        case timeCreated = "created_at"
        case timeUpdated = "updated_at"
        case projectId = "project_id"
        
        case id
        case name
        case order
        case finished
        case points
    }
    
    init(id: Int? = nil, name: String? = nil, order: String? = nil, finished: Bool? = nil, timeCreated: String? = nil, timeUpdated: String? = nil, projectId: Int? = nil, points: Int? = nil) {
        self.id = id
        self.name = name
        self.order = order
        self.finished = finished
        self.timeCreated = timeCreated
        self.timeUpdated = timeUpdated
        self.projectId = projectId
        self.points = points
    }
    
    // Used so that we can encode a project with all params
    // to send in a post request
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeCreated, forKey: .timeCreated)
        try container.encode(timeUpdated, forKey: .timeUpdated)
        try container.encode(projectId, forKey: .projectId)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(order, forKey: .order)
        try container.encode(finished, forKey: .finished)
        try container.encode(points, forKey: .points)
    }
}
