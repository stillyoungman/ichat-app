//
//  ConversationInfoProvider.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

typealias Conversations = [IConversationInfo]
// swiftlint:disable:next type_name
private typealias CI = ConversationInfo

class ConversationsInfoProvider {
    public static let instance = ConversationsInfoProvider()
    
    private let saPack: [(String, String)] = [
        ("Officer Frank Tenpenny", "See ya 'round, Carl. Like a 🍩 "),
        ("Carl Johnson", "You do know that I'm black, right? And not Chinese?"),
        ("Mike Toreno", "You know, after what you've done for me, it's like you're a pro now. I got double agents in Panama who want to put a price on your head."),
        ("Tommy Smith", "I've said it before... All we need is a little patience.")
    ]
    
    private let miscPack: [(String, String)] = [
        ("Bob Dylan", "I'm not sleepy and there is no place I'm going to"),
        ("Captain", "We haven't had that 🍷 here since 1969"),
        ("‎Grace Slick", "Go ask Alice, when she's ten feet tall and keep your head"),
        ("Canadian", "There's somethin' happenin' here, but what it is ain't exactly clear 😅"),
        ("Don McLean", "Did you write the book of love and do you have faith in God above, if the Bible tells you so?"),
        ("flowers&gats", "Why I'm here I can't quite remember, the surgeon general says it's hazardous to breathe"),
        ("John Fogerty", "It ain't me, it ain't me, I ain't no senator's son!"),
        ("David Gilmour", "Did you exchange, a walk on part in the war for a lead role in a cage?"),
        ("David Crosby", "Did he hear a good-bye? Or even hello?"),
        ("Jimmy Page", "Cause you know sometimes words have two meanings 🤷‍♂️"),
        ("master Oogway", "yesterday is history, tomorrow is a mystery, but today is a gift, that's why we call it the present."),
        ("Turkish", "What's happening with them sausages, Charlie? 😡"),
        ("Jake Green", "There is something about yourself that you don't know. Something that you will deny even exists, until it's too late to do anything about it. ")
    ]
    
    private lazy var dummyData = [
        CI(name: "Gabe Newell", message: "", date: Date().change(.hour, -1), isOnline: true, hasUnreadMessages: false),
        CI(name: "Homer Simpson", message: "", date: Date().change(.day, -21), isOnline: true, hasUnreadMessages: false),
        CI(name: saPack[0].0, message: saPack[0].1, date: Date().change(.hour, 1), isOnline: true, hasUnreadMessages: true),
        CI(name: saPack[1].0, message: saPack[1].1, date: Date().change(.minute, -43), isOnline: true, hasUnreadMessages: true),
        CI(name: saPack[2].0, message: saPack[2].1, date: Date().change(.hour, -6), isOnline: true, hasUnreadMessages: false),
        CI(name: saPack[3].0, message: saPack[3].1, date: Date().change(.minute, -246), isOnline: true, hasUnreadMessages: true),
        CI(name: miscPack[8].0, message: miscPack[8].1, date: Date().change(.day, -5), isOnline: true, hasUnreadMessages: false),
        CI(name: miscPack[6].0, message: miscPack[6].1, date: Date().change(.day, -15), isOnline: true, hasUnreadMessages: false),
        CI(name: miscPack[5].0, message: miscPack[5].1, date: Date().change(.minute, -1), isOnline: true, hasUnreadMessages: false),
        CI(name: miscPack[11].0, message: miscPack[11].1, date: Date().change(.minute, -14), isOnline: true, hasUnreadMessages: true),
        CI(name: miscPack[0].0, message: miscPack[0].1, date: Date().change(.month, -2), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[1].0, message: miscPack[1].1, date: Date().change(.year, -50), isOnline: false, hasUnreadMessages: false),
        CI(name: "Slim Shady", message: "", date: Date().change(.hour, -2), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[2].0, message: miscPack[2].1, date: Date().change(.minute, -1042), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[3].0, message: miscPack[3].1, date: Date().change(.hour, -31), isOnline: false, hasUnreadMessages: true),
        CI(name: miscPack[4].0, message: miscPack[4].1, date: Date().change(.second, -30), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[7].0, message: miscPack[7].1, date: Date().change(.hour, -2), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[9].0, message: miscPack[9].1, date: Date().change(.minute, -13), isOnline: false, hasUnreadMessages: true),
        CI(name: miscPack[10].0, message: miscPack[10].1, date: Date(), isOnline: false, hasUnreadMessages: false),
        CI(name: miscPack[12].0, message: miscPack[12].1, date: Date(), isOnline: false, hasUnreadMessages: false)
    ]
    
    private var onlineConversations: Conversations = [ConversationInfo]()
    private var historyConversations: Conversations = [ConversationInfo]()
    
    private func updateData<CSeq: Sequence>(_ conversations: CSeq) where CSeq.Element == IConversationInfo {
        onlineConversations = conversations
            .filter { $0.isOnline }
            .sorted { first, second in
                var result: Bool?
                result = first.sortByMessageAvailability(second)
                if let result = result { return result }
                
                #if EASTER_MODE
                //pull unread conversations on top
                result = first.sortByUnreadMessage(second)
                if let result = result { return result }
                #endif
                
                return first.date > second.date
            }
        
        historyConversations = conversations
            .filter { !($0.isOnline || $0.message.isEmpty) }
            .sorted { first, second in
                #if EASTER_MODE
                //pull unread conversations on top
                if let result = first.sortByUnreadMessage(second) { return result }
                #endif
                
                return first.date > second.date
            }
    }
    
    private init() {
        updateData(self.dummyData)
    }
}

extension ConversationsInfoProvider: IConversationsInfoProvider {
    func conversations(for type: ConversationType) -> AnyCollection<IConversationInfo> {
        switch type {
        case .online: return AnyCollection(onlineConversations)
        case .history: return AnyCollection(historyConversations)
        case .undefined: return AnyCollection([ConversationInfo]())
        }
    }
}
