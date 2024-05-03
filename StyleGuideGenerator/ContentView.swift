//
//  ContentView.swift
//  StyleGuideGenerator
//
//  Created by Xcode Developer on 5/2/24.
//

import SwiftUI
import UIKit
import Combine
import Observation
import Charts

@Observable class Hue: Equatable {
    static func == (lhs: Hue, rhs: Hue) -> Bool {
        return lhs.angle == rhs.angle
    }
    
    var angle: CGFloat = 0.0
    var value: CGFloat = 0.0
    
    struct Intensity: Identifiable {
        var position: Int
        var value: Double
        var id = UUID()
    }
}

struct ContentView: View {
    @State var hue = Hue()
    
    let positions = Array(0...11)
    let step: Double = (0.0 - 1.0) / 11
    var multipliers: [Double] = [0.0, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909, 0.090909]
    var values: [Double]  { return (0...11).map { Double($0) * step } }
    var intensities: [Hue.Intensity] {
        zip(positions, values).map { Hue.Intensity(position: $0, value: $1) }
    }
    
    private var _size: CGSize = CGSize.zero
    var size: CGSize {
        get {
            return ((UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height)
                    ? CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
                    : CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.height))
        }
        set {
            _size = newValue
        }
    }
    
    var body: some View {
        GeometryReader(content: { outerGeometry in
            VStack {
                HStack(alignment: .center, content: {
                    ColorWheelView(hue: hue,
                                   frameSize: CGSize(width: size.width * 0.4125, height: size.height * 0.4125),
                                   indicatorSize: CGSize(width: max(30.0, (size.width * 0.4125) * 0.075), height: max(30.0, (size.height * 0.4125) * 0.75)))
                    .frame(width: (size.width * 0.5), height: (size.height * 0.5))
                    .background {
                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
                            .foregroundStyle(.ultraThickMaterial)
                    }
                    Chart {
                        ForEach(intensities) { intensity in
                            PointMark(
                                x: .value("\(intensity.position)", intensity.position),
                                y: .value("\(intensity.value)", intensity.value)
                            )
                            
                        }
                    }
                })
            }
                
                
//                     .frame(width: outerGeometry.size.width, height: (size.height * 0.5))
            })
        VStack {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 6.0, content: {
                ForEach(intensities) { intensity in
                    RoundedRectangle(cornerRadius: 12.0, style: .circular)
                        .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: abs(intensity.value + 1.0)))
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay {
                            Text("\(intensity.position)\n\(abs(intensity.value + 1.0))")
                                .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: abs(intensity.value), brightness: 1.0))
                                .font(.footnote).dynamicTypeSize(.xSmall)
                        }
                }
            })
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 6.0, content: {
                ForEach(intensities) { intensity in
                    RoundedRectangle(cornerRadius: 12.0, style: .circular)
                        .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: abs(intensity.value), brightness: 1.0))
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay {
                            Text("\(intensity.position)\n\(-intensity.value)")
                                .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: abs(intensity.value + 1.0)))
                                .font(.footnote).dynamicTypeSize(.xSmall)
                        }
                }
            })
        }
        }
}

struct ColorWheelView: View {
    @Bindable var hue: Hue
    var frameSize: CGSize
    var indicatorSize: CGSize
    let minimumValue: CGFloat = 0.0
    let maximumValue: CGFloat = 360.0
    let totalValue: CGFloat = 360.0
    
    //    var _knobSize: CGSize = CGSize(width: 30.0, height: 30.0)
    //    var knobSize: CGSize {
    //        get { return _knobSize }
    //        set { _knobSize = newValue }
    //    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        var radius: CGFloat = (frameSize.width > frameSize.height) ? (frameSize.height / 2) : (frameSize.width / 2)
        var _diameter: CGSize = frameSize
        var diameter: CGSize {
            get { return _diameter }
            set { _diameter = newValue }
        }
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            // Wheel
            Circle()
                .strokeBorder(
                    AngularGradient(gradient: .init(colors: hueColors()), center: .center),
                    lineWidth: (frameSize.width < frameSize.height) ? indicatorSize.height : indicatorSize.width
                )
                .contentShape(Circle())
                .rotationEffect(.degrees(-90))
            
            // Spoke
            Circle()
                .fill(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 2.0))
                .frame(width: (frameSize.width < frameSize.height) ? indicatorSize.height : indicatorSize.width)
                .offset(y: -(radius - ((frameSize.width < frameSize.height) ? indicatorSize.height - (indicatorSize.height / 2) : indicatorSize.width - (indicatorSize.width / 2))))
                .rotationEffect(Angle.degrees(CGFloat(hue.angle).rounded()))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                        feedbackGenerator.impactOccurred()
                    }))
                .shadow(color: Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 0.0), radius: 15.0)
            
            
            Text(String(format: "%.0f°", ($hue.angle).wrappedValue))
                .font(.largeTitle).dynamicTypeSize(.xLarge)
                .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 1.0))
                .onChange(of: ($hue.angle).wrappedValue, { oldValue, newValue in
                    if (newValue != oldValue) {
                        hue.angle = newValue
                    }
                })
        })
        .frame(width: diameter.width, height: diameter.height)
        .fixedSize(horizontal: true, vertical: true)
    }
    
    func hueColors() -> [Color] {
        (0...360).map { i in
            Color(hue: CGFloat(i) / 360.0, saturation: 1.0, brightness: 1.0)
        }
    }
    //
    private func change(location: CGPoint) {
        // creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to subtract the knob radius and padding from the dy and dx
        let angle = atan2(vector.dy - (indicatorSize.width), vector.dx - (indicatorSize.width)) + .pi/2.0
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * totalValue
        
        if minimumValue >= 0.0 && maximumValue <= 360.0 {
            hue.angle = value.rounded()
            hue.value = fixedAngle * 180 / .pi // converting to degrees
        }
    }
}

struct SwatchView: View {
    @Bindable var hue: Hue
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 1.0))
        }
    }
}

#Preview {
    ContentView()
}
