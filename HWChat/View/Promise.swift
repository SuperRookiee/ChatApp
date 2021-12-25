//
//  Promise.swift
//  HWChat
//
//  Created by HyunWook on 2020/06/19.
//  Copyright © 2020 HyunWook. All rights reserved.
//

import SwiftUI

struct Promise: View {
    @Binding var promise: Bool
    @State private var selectedDate = Date()
    @State private var showingPopupA = false
    @State private var isAlert = false
    
    var body: some View {
        //Text("악속된 일정이 없어요").navigationBarTitle("일정",displayMode: .large)
        List {
            HStack {
                Text("고현욱")
                Text("1분뒤에 만나자").navigationBarTitle("일정",displayMode: .large).foregroundColor(Color("bg")).contextMenu{
                    Button(action: {
                            self.isAlert = true
                        }) {
                            Text("Click Alert")
                            .foregroundColor(Color.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .alert(isPresented: $isAlert) { () -> Alert in
                            Alert(title: Text("알람"), message: Text("약속한 일정이 있습니다."), primaryButton: .default(Text("OK"), action: {
                                print("Okay Click")
                            }), secondaryButton: .default(Text("Cancel")))
                    }
                }
                //<
                HStack {
                        Button(action: {
                            self.showingPopupA.toggle()
                        }, label: {
                            Text("              알림 설정하기")
                        }).popover(isPresented: self.$showingPopupA) {
                            VStack {
                                Button(action: {
                                    // Do something
                                    self.showingPopupA = false
                                }) {
                                    
                                    DatePicker(selection: self.$selectedDate) {
                                        Text("")
                                    }
                                    
                                    //.labelsHidden()
                                }
                                
                                
                                
                            }
                        }
                    }
                }
                //>

            }
        }
        
    }
