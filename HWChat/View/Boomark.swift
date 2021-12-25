//
//  Boomark.swift
//  HWChat
//
//  Created by HyunWook on 2020/07/01.
//  Copyright © 2020 HyunWook. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase
import Foundation

struct Bookmark: View {
    @Binding var marker: Bool
    //@ObservedObject var datas = firebaseData
    @State var data = [Pickmsg]()
    var uid : String
    
    var body: some View {
        VStack{
            List{
                ForEach(data){ i in
                    HStack {
                        Text(i.name)
                        Text(i.pickmsg).padding().foregroundColor(Color("bg"))
                        .contextMenu{
                        VStack{
                              Button(action: {
                                //DeleteBook(pickmsg: self.data.pickmsg, name: self.data.name, myuid: self.data.id) { (status) in}
                              })
                              {
                                  HStack{
                                      Text("북마크 삭제")
                                      Image(systemName: "trash").foregroundColor(.red)
                                  }
                              }
                            }
                        }
                    }
                }
            }.navigationBarTitle("모든 북마크",displayMode: .large)
            .onAppear {
                self.getPickMsgs()
            }
        }
    }
    
    func getPickMsgs(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("bookmarkSum").document(uid!).collection(uid!).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges{
                if i.type == .added{
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let pickmsg = i.document.get("pickmsg") as! String
                    
                    self.data.append(Pickmsg(id: id, name: name, pickmsg: pickmsg))
                }
            }
        }
        
    }
}


func CreateBook(pickmsg: String, name: String, myuid: String, date: Date, completion : @escaping (Bool)-> Void){

    let db = Firestore.firestore()

    let uid = Auth.auth().currentUser?.uid

    db.collection("bookmarkSum").document(uid!).collection(uid!).document().setData(["pickmsg":pickmsg, "name":name, "uid": myuid, "date" :date]) { (err) in

    if err != nil{

        print((err?.localizedDescription)!)
        return
        }
    }
    completion(true)

    UserDefaults.standard.set(true, forKey: "status")

    UserDefaults.standard.set(uid, forKey: "UID")

    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)

}

struct Pickmsg: Identifiable {
    var id: String
    var name: String
    var pickmsg: String
    
}

func DeleteBook(pickmsg: String, name: String, myuid: String, completion : @escaping (Bool)-> Void){
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    db.collection("bookmarkSum").document(uid!).collection("pickbookmark").document(myuid).delete() { (err) in
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }else {
            print("delete data success")
        }
    }
}
