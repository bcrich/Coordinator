//
//  Embeddable.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit
import TinyConstraints

public extension UIViewController {
	///	(view, parentView) -> Void
	public typealias LayoutBlock = (UIView, UIView) -> Void

	public func embed<T>(controller vc: T, into parentView: UIView?, layout: LayoutBlock = {
		v, pv in
		let constraints = v.edges(to: pv, isActive: false)
		constraints.forEach {
			$0.priority = UILayoutPriority(999)
			$0.isActive = true
		}
	})
		where T: UIViewController
	{
		let container = parentView ?? self.view!

		addChild(vc)
		container.addSubview(vc.view)
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		layout(vc.view, container)
		vc.didMove(toParent: self)

		//	Note: after this, save the controller reference
		//	somewhere in calling scope
	}

	public func unembed(controller: UIViewController?) {
		guard let controller = controller else { return }

		controller.willMove(toParent: nil)
		if controller.isViewLoaded {
			controller.view.removeFromSuperview()
		}
		controller.removeFromParent()

		//	Note: don't forget to nullify your own controller instance
		//	in order to clear it out from memory
	}
}

