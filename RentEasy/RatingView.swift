//
//  RatingView.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2024-03-24.
//

import SwiftUI

struct RatingView: View {
    @Environment(\.presentationMode) var presentationMode
    var posterUserID: String
    @State private var rating: Int? = nil
    @State private var feedback: String = ""
    
    var body: some View {
        Color.clear
            .edgesIgnoringSafeArea(.all)
            .overlay(
                
                //MARK: - RATING SUBVIEW
                VStack {
                    //MARK: -  DISMISS BUTTON
                    HStack {
                        Spacer()
                        Button("Close") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                        .foregroundColor(.black)
                    }
                    
                    //MARK: - Rating Star BUTTONS
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                self.rating = star
                            }) {
                                Image(systemName: star <= self.rating ?? 0 ? "star.fill" : "star")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(star <= self.rating ?? 0 ? .yellow : .gray)
                                    .frame(width: 40, height: 30)
                                
                            }
                        }
                    }
                    
                    //MARK: - Leave Feedback Label
                    HStack {
                        Text("Leave Feedback")
                            .font(.headline)
                            .padding(.top)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    //MARK: -  Text Editor
                    TextEditor(text: $feedback)
                        .frame(height: 100)
                        .border(Color.gray, width: 1)
                        .padding(.top, 5)
                    
                    
                    //MARK: -  SUBMIT BUTTON
                    Button("Submit") {
                        guard let _ = self.rating, !feedback.isEmpty else {
                            return
                        }
                        guard let currentUser = UserManager.shared.currentUser else {return}
                        let newRating = Rating(userID: UserManager.shared.currentUserId ?? "", firstName: currentUser.firstName , lastName: currentUser.lastName, value: rating ?? 0, feedback: feedback)
                        
                        RatingManager.shared.submitRating(forPosterUserID: posterUserID, rating: newRating)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                }
                    .padding()
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))                     .cornerRadius(30)
                    .padding(.horizontal, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            )
    }
}

#Preview {
    RatingView(posterUserID: "")
}
