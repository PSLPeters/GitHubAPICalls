//
//  ContentView.swift
//  GitHubAPICalls
//
//  Created by Michael Peters on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var avatar_url = ""
    @State private var login = ""
    @State private var bio = ""
    @State private var blog = ""
    @State private var followers = 0
    @State private var following = 0
    @State private var created_at = ""
    @State private var updated_at = ""
    
    struct Profiles : Identifiable {
        let id = UUID()
        let name : String
    }
    let arrProfiles =
        [
            Profiles(name: "huggingface"),
            Profiles(name: "sallen0400"),
            Profiles(name: "github"),
            Profiles(name: "google"),
            Profiles(name: "facebook"),
            Profiles(name: "flutter"),
            Profiles(name: "python"),
            Profiles(name: "Trinea"),
            Profiles(name: "RubyLouvre"),
            Profiles(name: "vuejs"),
            Profiles(name: "florinpop17"),
            Profiles(name: "bailicangdu"),
            Profiles(name: "kenjinote"),
            Profiles(name: "breakwa11"),
            Profiles(name: "nzakas"),
            Profiles(name: "mnielsen"),
            Profiles(name: "ghost"),
            Profiles(name: "daneden"),
            Profiles(name: "NeuralNine"),
            Profiles(name: "swisskyrepo"),
            Profiles(name: "pslpeters")
        ]
    
    @AppStorage("selectedScheme") private var selectedProfile = 0
    
    var body: some View {
        Text("GitHub User Information")
            .font(.title)
            .bold()
        Divider()
        VStack(spacing: 10) {
            AsyncImage(url: URL(string: avatar_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(Color.secondary)
            }
            .frame(width: 120, height: 120)
            Divider()
            Text(login)
                .bold()
                .font(.title3)
            Divider()
            Text("Bio: \(bio)")
            Spacer(minLength: 100)
            Divider()
            HStack {
                Text("Blog:")
                Spacer()
                Text(blog)
            }
            Divider()
            HStack {
                Text("Followers:")
                Spacer()
                Text(followers.withCommas())
            }
            Divider()
            HStack {
                Text("Following:")
                Spacer()
                Text(following.withCommas())
            }
            Divider()
            HStack {
                Text("Created:")
                Spacer()
                Text(created_at)
            }
            Divider()
            HStack {
                Text("Updated:")
                Spacer()
                Text(updated_at)
            }
            Divider()
            Spacer()
        }
        .opacity(login.isEmpty ? 0 : 1)
        .padding()
        HStack {
            Text("Select a profile to view:")
            Picker("Select Profile", selection: $selectedProfile) {
                ForEach(arrProfiles.indices, id:\.self) { oneIndex in
                    let foundCombo = arrProfiles[oneIndex]
                    Text((foundCombo.name))
                        .tag(oneIndex)
                }
            }
            .padding()
        }
        Button {
            Task {
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.github.com/users/\(arrProfiles[selectedProfile].name)")!)
                let decodedResponse = try? JSONDecoder().decode(user.self, from: data)
                avatar_url = decodedResponse?.avatar_url ?? ""
                login = decodedResponse?.login ?? ""
                bio = decodedResponse?.bio ?? ""
                blog = decodedResponse?.blog ?? ""
                followers = decodedResponse?.followers ?? 0
                following = decodedResponse?.following ?? 0
                created_at = decodedResponse?.created_at ?? ""
                updated_at = decodedResponse?.updated_at ?? ""
            }
        } label: {
            Text("Load")
        }
    }
}

struct user: Codable {
    let avatar_url: String
    let login: String
    let bio: String
    let blog: String
    let followers: Int
    let following: Int
    let created_at: String
    let updated_at: String
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

#Preview {
    ContentView()
}
