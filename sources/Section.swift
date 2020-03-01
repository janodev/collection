import UIKit

public struct Section
{
    public let model: Model
    public let rows: [Model]

    public init(title: String, rows: [Model]) {
        self.init(model: HeaderModel(title: title), rows: rows)
    }
    
    public init(model: Model, rows: [Model]) {
        self.model = model
        self.rows = rows
    }
}
