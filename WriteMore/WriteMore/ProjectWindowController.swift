//
//  ProjectWindowController.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/11/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

// TODO 1: Move this class.
// TODO 1: Take manager out of the name.
class ProjectWindowManager {
  
  var openProjects: [Project: ProjectWindowController]! = [Project: ProjectWindowController]()
  
  func windowControllerForProject(project: Project) -> ProjectWindowController! {
    var projectWindowController = openProjects[project]
    if projectWindowController == nil {
      projectWindowController = createProjectWindowControllerWithProject(project)
      openProjects[project] = projectWindowController
    }
    return projectWindowController
  }
  
  func createProjectWindowControllerWithProject(project: Project) -> ProjectWindowController! {
    let projectWindowController = ProjectWindowController(windowNibName: "ProjectWindowController")
    var projectViewController = ProjectViewController(nibName: "ProjectViewController", bundle: nil)
    if let pvc = projectViewController {
      pvc.project = project
      pvc.configureViewController()
      projectWindowController.projectViewController = pvc
      if let window = projectWindowController.window {
        window.contentView = pvc.view
        return projectWindowController
      } else {
        assertionFailure("Project window controller's window could not be loaded")
        return nil
      }
    }
    assertionFailure("Project view controller could not be loaded")
    return nil
  }
  
  func openProject(project: Project) {
    let projectWindowController = windowControllerForProject(project)
    projectWindowController.showWindow(self)
  }
  
  func projectClosed(project: Project) {
    if let projectWindowController = openProjects[project] {
      openProjects.removeValueForKey(project)
    } else {
      // TODO 1: Use a logging framework.
      println("WARNING: Closing a project that is not opened.")
    }
  }
  
}

class ProjectWindowController: NSWindowController, NSWindowDelegate {
  
  var project: Project?
  var projectWindowManager: ProjectWindowManager!
  // TODO 1: Create the pvc inside this window controller. (Actually, read the docs first then
  // set this up in the place where it makes the most since in mac world.)
  var projectViewController: ProjectViewController!
  
  override func windowDidLoad() {
    super.windowDidLoad()
    var app: AppDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    projectWindowManager = app.projectWindowManager
  }
  
  func windowWillClose(notification: NSNotification) {
    if let p = project {
      projectWindowManager.projectClosed(p)
    }
  }
  
}
