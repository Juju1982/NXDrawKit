//
//  Session.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 14..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit

class Session: NSObject
{
    private let maxSessionSize = 50
    private var undoSessionList = [Drawing]()
    private var redoSessionList = [Drawing]()
    private var backgroundSession: Drawing?
    
    override init() {
        super.init()
    }
    
    // MARK: - Private Methods
    private func appendUndo(session: Drawing?) {
        if session == nil {
            return
        }
        
        if self.undoSessionList.count >= self.maxSessionSize {
            self.undoSessionList.removeFirst()
        }
        
        self.undoSessionList.append(session!)
    }
    
    private func appendRedo(session: Drawing?) {
        if session == nil {
            return
        }
        
        if self.redoSessionList.count >= self.maxSessionSize {
            self.redoSessionList.removeFirst()
        }
        
        self.redoSessionList.append(session!)
    }
    
    private func resetUndo() {
        self.undoSessionList.removeAll()
    }
    
    private func resetRedo() {
        self.redoSessionList.removeAll()
    }
    
    // MARK: - Public Methods
    func lastSession() -> Drawing? {
        if self.undoSessionList.last != nil {
            return self.undoSessionList.last
        } else if self.backgroundSession != nil {
            return self.backgroundSession
        }
        
        return nil
    }
    
    func appendBackground(session: Drawing?) {
        if session != nil {
            self.backgroundSession = session
        }
    }
    
    func append(session: Drawing?) {
        self.appendUndo(session)
        self.resetRedo()
    }
    
    func undo() {
        let lastSession = self.undoSessionList.last
        if (lastSession != nil) {
            self.appendRedo(lastSession!)
            self.undoSessionList.removeLast()
        }
    }
    
    func redo() {
        let lastSession = self.redoSessionList.last
        if (lastSession != nil) {
            self.appendUndo(lastSession!)
            self.redoSessionList.removeLast()
        }
    }
    
    func clear() {
        self.resetUndo()
        self.resetRedo()
    }
    
    func canUndo() -> Bool {
        return self.undoSessionList.count > 0
    }

    func canRedo() -> Bool {
        return self.redoSessionList.count > 0
    }
    
    func canReset() -> Bool {
        return (self.canUndo() || self.canRedo())
    }
}
