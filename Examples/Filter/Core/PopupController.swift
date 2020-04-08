//
//  ActionSheet.swift
//  Megadisk
//
//  Created by Igor Vedeneev on 8/25/19.
//  Copyright © 2019 AGIMA. All rights reserved.
//

import UIKit

/// Контейнер для поповеров (например, пикер фото или действия с файлами)
final class PopupController<T: PopupContentView>: PortraitOrientationViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var interactor = PopupAnimationInteractor()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let content = T()
    let pinView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let dismissTouchReceivingView = UIView(frame: view.bounds)
        view.addSubview(dismissTouchReceivingView)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(_dismiss))
        dismissTouchReceivingView.addGestureRecognizer(tapGR)
        tapGR.delegate = self
        
        view.addSubview(content.view)
        addChild(content)
        content.didMove(toParent: self)
        content.view.frame = content.frameInPopup
        
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan1.delegate = self
        content.view.addGestureRecognizer(pan1)
        content.view.isUserInteractionEnabled = true
        
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan2.delegate = self
        content.scrollView?.addGestureRecognizer(pan2)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer { return true }
        
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer, let panView = pan.view else { return false }
                
        let velocity = pan.velocity(in: panView)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        let isEnabled: Bool
        if let scrollView = panView as? UIScrollView {
            isEnabled = scrollView.contentOffset.y <= 0 && velocity.y > 0
        } else {
            isEnabled = true
        }
        return isVertical && isEnabled
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.4
        let translation = sender.translation(in: contentView)
        let verticalMovement = translation.y / contentFrame.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        var progress = CGFloat(downwardMovementPercent)
        progress = progress * 0.7
        print(progress)
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            print(interactor.shouldFinish)
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
    
    @objc func _dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return FadeAnimator(type: .present, contentView: contentView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return FadeAnimator(type: .dismiss, contentView: contentView)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionType {
        case present
        case dismiss
    }
    
    let type: TransitionType
    let duration: TimeInterval
    var contentView: UIView
    
    init(type: TransitionType, duration: TimeInterval = 0.3, contentView: UIView) {
        self.type = type
        self.duration = duration
        self.contentView = contentView
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let transVC: PopupControllerProtocol
        if type == .present {
            transVC = toVC as! PopupControllerProtocol
            transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
            transVC.contentView.transform = CGAffineTransform(translationX: 0, y: transVC.contentFrame.height)
        } else {
            transVC = fromVC as! PopupControllerProtocol
        }
        
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(.linear)
            if self.type == .present {
                toVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                transVC.contentView.transform = .identity
            } else {
                fromVC.view.backgroundColor = .clear
                transVC.contentView.transform = CGAffineTransform(translationX: 0, y: transVC.contentFrame.height)
            }
            
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class PortraitOrientationViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

final class PopupAnimationInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

protocol PopupContentView: UIViewController {
    var frameInPopup: CGRect { get }
    var scrollView: UIScrollView? { get }
    func setupKeyboardObserving()
    func roundCorners()
}

protocol PopupControllerProtocol: UIViewController, UIViewControllerTransitioningDelegate {
    var contentView: UIView { get }
    var contentFrame: CGRect { get }
}

extension PopupController: PopupControllerProtocol {
    var contentView: UIView {
        return content.view
    }
    
    var contentFrame: CGRect {
        return content.frameInPopup
    }
}

extension PopupContentView {
    func setupKeyboardObserving() {
        let o1 = NotificationCenter.default
            .addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] (note) in
                guard
                    let `self` = self,
                    let duration: TimeInterval = note.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
                    let curve: UInt = note.userInfo?["UIKeyboardAnimationCurveUserInfoKey"] as? UInt,
                    let endFrame: CGRect = note.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
                else { return }
                
                UIView.animate(withDuration: duration,
                   delay: 0,
                   options: [UIView.AnimationOptions(rawValue: curve)],
                   animations: {
                    self.view.frame.origin.y = endFrame.minY - self.view.bounds.height
                   }, completion: nil)
            }
    }
    
    func roundCorners() {
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
    }
}
