//
//  Brew.swift
//  brewd
//
//  Created by mxa on 24.10.2017.
//  Copyright © 2017 mxa. All rights reserved.
//

import Foundation

/// Available brew commands.
enum BrewCommand: String {
    case list
    case outdated
    case update
}

/// A wrapper for executing brew commands.
struct Brew {
    let executablePath: String

    /// Calls `brew update`.
    ///
    /// - Returns: Whether the update was successful or not.
    func update() -> Bool {
        let update = try? run(.update)
        return update != nil
    }


    /// Calls `brew list`.
    ///
    /// - Returns: The list of installed packages, or nil if the call failed.
    func installedPackages() -> [String] {
        guard
            let listResult = try? self.run(.list),
            let list = listResult
            else { return [] }
        return list.components(separatedBy: "\n").filter { $0 != "" }
    }

    /// Calls `brew outdated`.
    ///
    /// - Returns: The list of outdated packages, or nil if the call failed.
    func outdatedPackages() -> [String] {
        guard
            let outdatedResult = try? self.run(.outdated),
            let outdated = outdatedResult
        else { return [] }
        return outdated.components(separatedBy: "\n").filter { $0 != "" }
    }
}


// MARK: - Execute brew commands

private extension Brew {
    func run(_ command: BrewCommand) throws -> String? {
        let result = Command.runSynchronously(self.executablePath, command.rawValue)

        if let stderr = result.stderr, !stderr.isEmpty {
            throw BrewError(message: stderr)
        }
        return result.stdout
    }

    struct BrewError: Error {
        let message: String
    }
}
