//
//  GetContactUtils.swift
//  SaleSecretary
//
//  Created by Lutiguang on 2017/8/10.
//  Copyright © 2017年 zjjy. All rights reserved.
//

import Foundation
import UIKit

import Contacts

struct GetContactUtils {

    static let contactStore = CNContactStore()
    
    static let keys = [ CNContactFamilyNameKey,CNContactGivenNameKey, CNContactJobTitleKey , CNContactDepartmentNameKey,CNContactNoteKey, CNContactPhoneNumbersKey,
                 CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                 CNContactDatesKey, CNContactInstantMessageAddressesKey ,
                 CNContactNicknameKey , CNContactOrganizationNameKey , CNContactBirthdayKey , CNContactIdentifierKey ]
    
    static let keySimple = [CNContactFamilyNameKey , CNContactGivenNameKey , CNContactPhoneNumbersKey ]
    
    static func loadContactData() -> [Customer] {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized else {
            NSLog(" auth failed !")
            return []
        }
        var dt : [Customer] = []
        let request = CNContactFetchRequest(keysToFetch: self.keys as [CNKeyDescriptor])
        
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: {
                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                let firstName = contact.givenName
                let lastName = contact.familyName
                let nickName = contact.nickname
                let company = contact.organizationName
                let birthday  = contact.birthday?.date
                var strBirthday = ""
                let identifier = contact.identifier
                if birthday != nil {
                    strBirthday = DateFormatterUtils.getStringFromDate(birthday!, dateFormat: "yyyy-MM-dd")
                }
                var pNumber : [String] = []
                for phone in contact.phoneNumbers {
                    if phone.label != nil {
                        let value = phone.value.stringValue
                        pNumber.append(value)
                    }
                }
                
                dt.append(Customer.init(birth: strBirthday , company: company , nick_name: nickName , phone_number: pNumber , name: lastName + firstName , id : identifier) )
            })
        } catch {
            NSLog(error as! String)
        }
        //self.tableView.reloadData()
        NSLog("Get Contacts count : \(dt.count)")
        return dt
    }
    
    static func secondWay2GetContactData() -> [Customer] {
        var arrContacts = [CNContact]()
        var allContainers: [CNContainer] = []
        
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: self.keys as [CNKeyDescriptor])
                arrContacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        return toCustomer(contact: arrContacts)
    }
    
    static func simpleWay2GetContactData(_ completion: (_ success: Bool, _ contacts: [Customer] ) -> Void) {
        var arrContacts = [CNContact]()
        var allContainers: [CNContainer] = []
        var flag = true
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            flag = false
            print("Error fetching containers")
        }
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: self.keySimple as [CNKeyDescriptor])
                arrContacts.append(contentsOf: containerResults)
                
            } catch {
                flag = false
                print("Error fetching results for container")
            }
        }
        completion( flag , simpleCustomer(contact: arrContacts))
    }
    
    static func simpleWay2GetContactData2( _ completion: (_ success: Bool, _ contacts: [Customer] ) -> Void ){
        var result : [Customer] = []
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = Customer(cnContact: cnContact) {
                    result.append(contact)
                }
            })
            completion(true, result)
        } catch {
            completion(false, result)
        }
    }
    
    static func simpleCustomer(contact : [CNContact]) -> [Customer] {
        var result = [Customer]()
        if contact.count > 0 {
            for c in contact {
                var pNumber : [String] = []
                for phone in c.phoneNumbers {
                    if phone.label != nil {
                        let value = phone.value.stringValue
                        pNumber.append(value)
                    }
                }
                result.append(Customer.init(name: c.familyName+c.givenName , phoneNum: pNumber ) )
            }
        }
        return  result
    }
    
    static func toCustomer(contact : [CNContact]) -> [Customer] {
        var result = [Customer]()
        if contact.count > 0 {
            for c in contact {
                var pNumber : [String] = []
                for phone in c.phoneNumbers {
                    if phone.label != nil {
                        let value = phone.value.stringValue
                        pNumber.append(value)
                    }
                }
                let birthday  = c.birthday?.date
                var strBirthday = ""
                if birthday != nil {
                    strBirthday = DateFormatterUtils.getStringFromDate(birthday!, dateFormat: "yyyy-MM-dd")
                }
                result.append(Customer.init(birth:  strBirthday , company: c.organizationName , nick_name: c.nickname , phone_number: pNumber , name: c.familyName+c.givenName , id: c.identifier))
            }
        }
        return  result
    }
    
    func loadContactsData() {
        //获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        //判断当前授权状态
        guard status == .authorized else { return }
        //创建通讯录对象
        let store = CNContactStore()
        //获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey,
                    CNContactOrganizationNameKey, CNContactJobTitleKey,
                    CNContactDepartmentNameKey, CNContactNoteKey, CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                    CNContactDatesKey, CNContactInstantMessageAddressesKey
        ]
        //创建请求对象，需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含'CNKeyDescriptor'类型的数组
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        //遍历所有联系人
        do {
            try store.enumerateContacts(with: request, usingBlock: {
                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                //获取姓名
                let lastName = contact.familyName
                let firstName = contact.givenName
                print("姓名：\(lastName)\(firstName)")
                //获取昵称
                let nikeName = contact.nickname
                print("昵称：\(nikeName)")
                //获取公司（组织）
                let organization = contact.organizationName
                print("公司（组织）：\(organization)")
                //获取职位
                let jobTitle = contact.jobTitle
                print("职位：\(jobTitle)")
                //获取部门
                let department = contact.departmentName
                print("部门：\(department)")
                //获取备注
                let note = contact.note
                print("备注：\(note)")
                //获取电话号码
                print("电话：")
                for phone in contact.phoneNumbers {
                    //获得标签名（转为能看得懂的本地标签名，比如work、home）
                    if phone.label != nil{
                        let label = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
                        //获取号码
                        let value = phone.value.stringValue
                        print("\t\(label)：\(value)")
                    }
                }
                //获取Email
                print("Email：")
                for email in contact.emailAddresses {
                    if email.label != nil{
                        //获得标签名（转为能看得懂的本地标签名）
                        let label = CNLabeledValue<NSString>.localizedString(forLabel: email.label!)
                        //获取值
                        let value = email.value
                        print("\t\(label)：\(value)")
                    }
                }
                //获取地址
                print("地址：")
                for address in contact.postalAddresses {
                    if address.label != nil{
                        //获得标签名（转为能看得懂的本地标签名）
                        let label = CNLabeledValue<NSString>.localizedString(forLabel: address.label!)
                        //获取值
                        let detail = address.value
                        let contry = detail.value(forKey: CNPostalAddressCountryKey) ?? ""
                        let state = detail.value(forKey: CNPostalAddressStateKey) ?? ""
                        let city = detail.value(forKey: CNPostalAddressCityKey) ?? ""
                        let street = detail.value(forKey: CNPostalAddressStreetKey) ?? ""
                        let code = detail.value(forKey: CNPostalAddressPostalCodeKey) ?? ""
                        let str = "国家:\(contry) 省:\(state) 城市:\(city) 街道:\(street) 邮编:\(code)"
                        print("\t\(label)：\(str)")
                    }
                }
//                //获取纪念日
//                print("纪念日：")
//                for date in contact.dates {
//                    if date.label != nil{
//                        //获得标签名（转为能看得懂的本地标签名）
//                        let label = CNLabeledValue<NSString>.localizedString(forLabel: date.label!)
//                        //获取值
//                        let dateComponents = date.value as DateComponents
//                        let value = NSCalendar.current.date(from: dateComponents)
//                        let dateFormatter = DateFormatter()
////                        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
////                        print("\t\(label)：\(dateFormatter.string(from: value!))")
//                    }
//                }
                //获取即时通讯(IM)
                print("即时通讯(IM)：")
                for im in contact.instantMessageAddresses {
                    if im.label != nil{
                        //获得标签名（转为能看得懂的本地标签名）
                        let label = CNLabeledValue<NSString>.localizedString(forLabel: im.label!)
                        //获取值
                        let detail = im.value
                        let username = detail.value(forKey: CNInstantMessageAddressUsernameKey) ?? ""
                        let service = detail.value(forKey: CNInstantMessageAddressServiceKey) ?? ""
                        print("\t\(label)：\(username) 服务:\(service)")
                    }
                }
                print("----------------")
            })
        } catch {
            print(error)
        }
    }
}
