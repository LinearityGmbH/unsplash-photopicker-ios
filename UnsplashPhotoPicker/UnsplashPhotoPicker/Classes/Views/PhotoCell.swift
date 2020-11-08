//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "PhotoCell"

    let photoView: PhotoView = {
        // swiftlint:disable force_cast
        let photoView = (PhotoView.nib.instantiate(withOwner: nil, options: nil).first as! PhotoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.layer.cornerRadius = 8.0
        photoView.layer.masksToBounds = true
        return photoView
    }()

    private lazy var checkmarkView: CheckmarkView = {
        return CheckmarkView()
    }()

    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }

    // MARK: - Lifetime

    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }

    private func postInit() {
        setupPhotoView()
        setupNewCheckmarkView()
        //setupCheckmarkView()
        updateSelectedState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.prepareForReuse()
    }

    private func updateSelectedState() {
        //photoView.alpha = isSelected ? 0.7 : 1
        //checkmarkView.alpha = isSelected ? 1 : 0
        if isSelected == true {
            animateNewCheckmark()
        }
    }

    // Override to bypass some expensive layout calculations.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return .zero
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto) {
        photoView.configure(with: photo)
    }

    private func setupPhotoView() {
        contentView.preservesSuperviewLayoutMargins = true
        contentView.addSubview(photoView)
        NSLayoutConstraint.activate([
            //photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            //photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            //photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            //photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

            photoView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: CGFloat(1)),
            photoView.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.bottomAnchor, multiplier: CGFloat(-1)),
            photoView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: CGFloat(1)),
            photoView.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.trailingAnchor, multiplier: CGFloat(-2))
        ])
    }

    private func setupCheckmarkView() {
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkView)
        NSLayoutConstraint.activate([
            contentView.rightAnchor.constraint(equalToSystemSpacingAfter: checkmarkView.rightAnchor, multiplier: CGFloat(1)),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: checkmarkView.bottomAnchor, multiplier: CGFloat(1))
            ])
    }

    private func setupNewCheckmarkView() {
        contentView.addSubview(newCheckmarkView)
        contentView.addSubview(blurEffectView)
    }

    private lazy var newCheckmarkView: UIView = {
        let newCheckmarkView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let checkmarkImage = newCheckmarkImageView
        checkmarkImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        newCheckmarkView.addSubview(checkmarkImage)
        newCheckmarkView.center = contentView.center
        return newCheckmarkView
    }()

    private lazy var newCheckmarkImageView: UIImageView = {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "newCheckmark", in: bundle, compatibleWith: nil)
        return UIImageView(image: image)
    }()

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.0
        return blurEffectView
    }()

    private func animateNewCheckmark() {

        newCheckmarkImageView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.alpha = 0.4
            self.newCheckmarkImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.4, animations: {() -> Void in
                self.blurEffectView.alpha = 0.0
                self.newCheckmarkImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: {(_ finished: Bool) -> Void in
                self.newCheckmarkImageView.isHidden = true
            })
        })

    }
}
