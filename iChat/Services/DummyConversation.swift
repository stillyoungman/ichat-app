//
//  DummyConversation.swift
//  iChat
//
//  Created by Constantine Nikolsky on 07.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

class DummyConversation: IConversation {
    var uid: String = ""
    var messages: [Date: [IMessage]] = [:]
    var dates: [Date] = []
    
    init() {
        dates = [ data[0].date ]
        messages[data[0].date] = data
    }
    
    static func dummyMessage(_ text: String, _ isOutgoing: Bool) -> IMessage {
        TextMessage(text: text, uid: "",
                    time: "", deliveryStatus: .delivered,
                    senderUid: "", isOutgoing: isOutgoing,
                    date: Date(timeIntervalSince1970: TimeInterval()))
    }
    
    func getMessage(for indexPath: IndexPath) -> IMessage {
        guard let messages = messages[getDate(for: indexPath)] else { fatalError("Index out of range")}
        return messages[indexPath.row]
    }
    
    func getDate(for indexPath: IndexPath) -> Date {
        dates[indexPath.section]
    }
    
    // swiftlint:disable line_length
    let data = [
        dummyMessage("hi)", false),
        dummyMessage("👋", true),
        dummyMessage("At vero eos et accusamus et iusto odio dignissimos", false),
        dummyMessage("laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat ", true),
        dummyMessage("Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis", false),
        dummyMessage("debitis aut rerum necessitatib", false),
        dummyMessage("rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus", true),
        dummyMessage("voluptate velit esse cillum dolore eu fugiat nulla pariatur", true),
        dummyMessage("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatu", true),
        dummyMessage("consectetur adipiscing elit", false),
        dummyMessage("laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat", true),
        dummyMessage("Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis", false),
        dummyMessage("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore e", true)
    ]
}
