//
//  ToastAlert.swift
//  MINT
//
//  Created by choymoon on 2022/04/06.
//

import UIKit

class ToastAlert {
    private var view: UIView?
    private var label: UILabel?
    private var isShowing: Bool = false

    init() { }

    deinit {
        view = nil
        label = nil
    }

    func show(title: String, labelColor: UIColor? = .pointRed,
              textColor: UIColor? = .white,
              lines: CGFloat = 1,
              duration: TimeInterval = 1.5,
              isTop: Bool = false) {
        if !isShowing {
            isShowing = true
            let view = UIView()
            view.backgroundColor = labelColor
            let label = UILabel()
            label.numberOfLines = 0
            label.text = title
            label.textColor = textColor
            label.font = .pretendard(.black, size: 14, false)
            label.textAlignment = .center
            
            view.addSubview(label)

            label.snp.makeConstraints { (make) in
                if isTop {
                    make.bottom.equalToSuperview().offset(-10)
                } else {
                    make.top.equalToSuperview().offset(10)
                }
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }

            let height: CGFloat = {
                if isTop {
                    return (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0) + 35 + (12.5 * lines)
                } else {
                    return (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0) + 35 + (12.5 * lines)
                }
            }()

            self.view = view
            self.label = label

            if let window = UIApplication.shared.keyWindow {
                window.insertSubview(view, at: 10)
                view.snp.makeConstraints { (make) in
                    if isTop {
                        make.top.equalToSuperview()
                    } else {
                        make.bottom.equalToSuperview()
                    }
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                        view.snp.updateConstraints { (make) in
                            make.height.equalTo(height)
                        }
                        window.layoutIfNeeded()
                    }, completion: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            self.hide()
                        }
                    })
                }
            }
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.33, animations: {
            self.view!.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            UIApplication.shared.keyWindow?.layoutIfNeeded()
        }, completion: { _ in self.view?.removeFromSuperview(); self.view = nil; self.label = nil; self.isShowing = false })
    }
}
