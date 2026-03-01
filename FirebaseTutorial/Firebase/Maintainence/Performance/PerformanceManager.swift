//
//  PerformanceManager.swift
//  FirebaseTutorial
//
//  Created by Youssef Mohamed on 01/03/2026.
//

import SwiftUI
import Combine
import FirebasePerformance

final class PerformanceManager {
    
    static let shared = PerformanceManager()
    private init() { }
    
    private var traces: [String:Trace] = [:]
    
    func startTrace(name: String) {
        traces[name] = Performance.startTrace(name: name)
    }
    
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    
    func stopTrace(name: String) {
        guard let trace = traces[name] else { return }
        trace.stop()
        traces.removeValue(forKey: name)
    }
}

final class PerformanceViewModel: ObservableObject {
    
    func configure() {
        /// Traces the duration of a background task and records its internal state changes
        PerformanceManager.shared.startTrace(name: "performance_view_loading")

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "performance_view_loading", value: "Started downloading", forAttribute: "func_state")
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformanceManager.shared.setValue(name: "performance_view_loading", value: "Finished downloading", forAttribute: "func_state")

            PerformanceManager.shared.stopTrace(name: "performance_view_loading")
        }
    }
    
    func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let metric = HTTPMetric(url: url, httpMethod: .get) else { return }
        
        metric.start() /// Starts tracing the network request lifecycle

        Task {
            do {
                let (_, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
                print("SUCCESS")
            } catch {
                print(error)
                metric.stop()
            }
        }
    }
}

struct PerformanceView: View {
    @StateObject private var vm = PerformanceViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header Description
                    Text("Trigger and monitor custom performance traces and network metrics. Screen time is tracked automatically.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // MARK: - Trace 1: Custom Background Task
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.orange)
                            Text("Simulate Background Task")
                                .font(.headline)
                        }
                        
                        Text("Trace: `performance_view_loading`\nTakes 4s total. Updates `func_state` attribute mid-flight.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            vm.configure()
                        }) {
                            Text("Start Background Trace")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Trace 2: Network Metric
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "network")
                                .foregroundColor(.blue)
                            Text("Network Performance")
                                .font(.headline)
                        }
                        
                        Text("Metric: HTTP GET to `dummyjson.com`\nRecords duration and auto-attaches the HTTP status code.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            vm.downloadProductsAndUploadToFirebase()
                        }) {
                            Text("Trigger Network Request")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // MARK: - Lifecycle Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "hourglass.circle.fill")
                                .foregroundColor(.green)
                            Text("Screen Time (Auto-logged)")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Started onAppear", systemImage: "play.circle.fill")
                            Label("Stops onDisappear", systemImage: "stop.circle.fill")
                            Text("Trace: `performance_screen_time`")
                                .font(.caption.monospaced())
                                .padding(.top, 4)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Performance Tracker")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Auto-logged Screen Time Trace
            .onAppear {
                PerformanceManager.shared.startTrace(name: "performance_screen_time")
            }
            .onDisappear {
                PerformanceManager.shared.stopTrace(name: "performance_screen_time")
            }
        }
    }
}

struct PerformanceView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceView()
    }
}
