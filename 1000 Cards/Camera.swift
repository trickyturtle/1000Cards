//
//  Camera.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/28/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import MobileCoreServices
import JSQMessagesViewController

class Camera {
    
    class func startCamera(_ target: AnyObject, canEdit: Bool, frontFacing: Bool) -> Void {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false {
            return
        }
        
        let type = kUTTypeImage as String
        let cameraUI = UIImagePickerController()
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera) as [String]!
        
        let available = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) && (availableMediaTypes?.contains(type))!
        
        if available {
            cameraUI.mediaTypes = [type]
            cameraUI.sourceType = UIImagePickerControllerSourceType.camera
            
            /* Prioritize front or rear camera */
            if (frontFacing == true) {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.front
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.rear
                }
            } else {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.rear
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.front
                }
            }
        } else {
            return
        }
        
        cameraUI.allowsEditing = canEdit
        cameraUI.showsCameraControls = true
        if target is MessageBoardViewController {
            cameraUI.delegate = target as! MessageBoardViewController
        }
        target.present(cameraUI, animated: true, completion: nil)
        
        return
    }

    class func startPhotoLibrary(_ target: AnyObject, canEdit: Bool) -> Void {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        let availableMediaTypesPL = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary) as [String]!
        let availableMediaTypesSPA = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum) as [String]!
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && (availableMediaTypesPL?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) && (availableMediaTypesSPA?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        if target is MessageBoardViewController {
            imagePicker.delegate = target as! MessageBoardViewController
        }
        target.present(imagePicker, animated: true, completion: nil)
        
        return
    }
    
    class func startVideoLibrary(_ target: AnyObject, canEdit: Bool) -> Void {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return
        }
        
        let type = kUTTypeMovie as String
        let imagePicker = UIImagePickerController()
        let availableMediaTypesPL = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary) as [String]!
        let availableMediaTypesSPA = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum) as [String]!
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && (availableMediaTypesPL?.contains(type))!{
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) && (availableMediaTypesSPA?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = target as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        target.present(imagePicker, animated: true, completion: nil)
        
        return
    }
}
