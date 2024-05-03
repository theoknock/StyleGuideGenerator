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
    var step:  CGFloat = 20.0
    
    struct Intensity: Identifiable {
        var position: Int
        var value: Double
        var id = UUID()
    }
    
    func normalizedHue(hue: Double, addDegrees: Double) -> Double {
        let newHue = (hue + addDegrees).truncatingRemainder(dividingBy: 360.0)
        return newHue < 0 ? (newHue + 360) / 360 : newHue / 360
    }
}

struct ContentView: View {
    @State var hue = Hue()
    
    let positions = Array(0...11)
    let step: Double = (1.0 - 0.00) / 11
    var values: [Double]  { return (0..<11).map { Double($0) * step } }
    var intensities: [Hue.Intensity] {
        zip(positions, values).map { Hue.Intensity(position: $0, value: $1) }
    }
    //        var hueValues: Array<Double>  { return Array(arrayLiteral: (0..<11).map { Double($0) * step }) }
    //        var saturationValues: Array<Double>  { return (0..<11).map { Double($0) * step } }
    //        var brightnessValues: Array<Double>  { return (0..<11).map { Double($0) * step } }
    //        var values: Array<Array<[Double]>> { return Array<Array<[Double]>>(arrayLiteral: Array(hueValues, saturationValues, brightnessValues) }
    //        var hueValues: [Double]  { return scaleBatch(data: (0...11).map { Double($0) * step }, newMin: hue.angle - hue.step, newMax: hue.angle + hue.step) }
    //        var saturationValues: [Double]  { return /*scaleBatch(data: */(0...11).map { Double($0) * step }/*, newMin: 0.0, newMax: 1.0)*/ }
    //        var brightnessValues: [Double]  { return /*scaleBatch(data: */(0...11).map { Double($0) * step }/*, newMin: 0.0, newMax: 1.0)*/ }
    
    //        var intensities: [Hue.Intensity] {
    //            zip(positions, values).map { Hue.Intensity(position: $0, value: $1) }
    //            }
    //
    //
    
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
        HStack(alignment: .center, content: {
            VStack(alignment: .center, content: {
                // first row
                HStack(alignment: .center, content: {
//                    Text("first row")
                    // columns
                    VStack(alignment: .center, content: {
                            ColorWheelView(hue: hue,
                                           frameSize: CGSize(width: size.width * 0.25, height: size.height * 0.25),
                                           indicatorSize: CGSize(width: 30.0, height: 30.0))
//                                            .frame(minWidth: size.width * 0.25, idealWidth: size.width * 0.3333, maxWidth: size.width * 0.3333, minHeight: size.height * 0.25, idealHeight: size.height * 0.3333, maxHeight: size.height, alignment: .center))
//                                            .background {
//                                                RoundedRectangle(cornerRadius: max(30.0, CGFloat((size.width * 0.25) * 0.075, style: .circular)
//                                                    .foregroundStyle(.ultraThin)
//                                            })
                    })
                    .frame(minWidth: size.width * 0.25, idealWidth: size.width * 0.3333, maxWidth: size.width, minHeight: size.height * 0.25, idealHeight: size.height * 0.3333, maxHeight: size.height, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                    
                    VStack(alignment: .center, content: {
                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
                            .foregroundColor(Color(hue:
                                                    hue.normalizedHue(hue: hue.angle, addDegrees: -hue.step), saturation: 1.0, brightness: 1.0)) // Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
                        //                            .overlay {
                        //                                Text("\(CGFloat(hue.angle - hue.step) / 360.0)")
                        //                                    .foregroundStyle(.regularMaterial)
                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
                        
                            .aspectRatio(1.0, contentMode: .fit)
                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
                            .foregroundColor(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 1.0)) //.foregroundStyle(Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
                        //                            .overlay {
                        //                                Text("\(CGFloat(hue.angle) / 360.0)")
                        //                                    .foregroundStyle(.regularMaterial)
                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
                        //                            }
                            .aspectRatio(1.0, contentMode: .fit)
                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
                            .foregroundColor(Color(hue: hue.normalizedHue(hue: hue.angle, addDegrees: hue.step), saturation: 1.0, brightness: 1.0)) //.foregroundStyle(Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
                        //                            .overlay {
                        //                                Text("\(CGFloat(hue.angle + hue.step) / 360.0)")
                        //                                    .foregroundStyle(.regularMaterial)
                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
                        //                            }
                            .aspectRatio(1.0, contentMode: .fit)
                        Stepper("\(hue.step)", value: $hue.step, in: 0...360, step: 1)
                    })
                    .frame(minWidth: size.width * 0.25, idealWidth: size.width * 0.3333, maxWidth: size.width, minHeight: size.height * 0.25, idealHeight: size.height * 0.3333, maxHeight: size.height, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                    
                    VStack(alignment: .center, content: {
                        Text("column")
                    })
                    .frame(minWidth: size.width * 0.25, idealWidth: size.width * 0.3333, maxWidth: size.width, minHeight: size.height * 0.25, idealHeight: size.height * 0.3333, maxHeight: size.height, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                })
                .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: size.height * 0.25, idealHeight: size.height * 0.3333, maxHeight: size.height, alignment: .center)
                .padding([.horizontal, .vertical])
                .background(.clear.opacity(0.0))
                .foregroundStyle(.regularMaterial)
                .border(.orange, width: 10)
                
                // second row
                VStack(alignment: .center, content: {
                    Text("second row")
                    // rows
                    HStack(alignment: .center, content: {
                        Text("row")
                    })
                    .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: (size.height * 0.5) * 0.25, idealHeight: (size.height * 0.5) * 0.3125, maxHeight: (size.height * 0.5) * 0.3125, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                    
                    HStack(alignment: .center, content: {
                        Text("row")
                    })
                    .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: (size.height * 0.5) * 0.25, idealHeight: (size.height * 0.5) * 0.3125, maxHeight: (size.height * 0.5) * 0.3125, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                    
                    HStack(alignment: .center, content: {
                        Text("row")
                    })
                    .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: (size.height * 0.5) * 0.25, idealHeight: (size.height * 0.5) * 0.3125, maxHeight: (size.height * 0.5) * 0.3125, alignment: .center)
                    .background(.clear.opacity(0.0))
                    .foregroundStyle(.thinMaterial)
                    .border(.purple, width: 10)
                    
                })
                .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: size.height * 0.3333, idealHeight: size.height * 0.5, maxHeight: size.height * 0.6667, alignment: .center)
                .padding([.horizontal, .vertical])
                .background(.clear.opacity(0.0))
                .foregroundStyle(.regularMaterial)
                .border(.orange, width: 10)
            })
            .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: size.height * 0.5, idealHeight: size.height, maxHeight: size.height, alignment: .center)
            .padding([.horizontal, .vertical])
            .background(.clear.opacity(0.0))
            .foregroundStyle(.thickMaterial)
            .border(.red, width: 10)
        })
        .frame(minWidth: size.width * 0.5, idealWidth: size.width, maxWidth: size.width, minHeight: size.height * 0.5, idealHeight: size.height, maxHeight: size.height, alignment: .center)
        .padding([.horizontal, .vertical])
        .background(Color(uiColor: UIColor(white: 1.0, alpha: 1.0)))
        .foregroundStyle(.ultraThickMaterial)
        .border(.green, width: 10)
    }
}


//            VStack {                                             // VStack 1
//                HStack(alignment: .center, content: {            // HStack 2
//                    ColorWheelView(hue: hue,
//                                   frameSize: CGSize(width: size.width * 0.4125, height: size.height * 0.4125),
//                                   indicatorSize: CGSize(width: max(30.0, (size.width * 0.4125) * 0.075), height: max(30.0, (size.height * 0.4125) * 0.75)))
//                    .frame(width: (size.width * 0.5), height: (size.height * 0.5))
//                    .background {
//                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
//                            .foregroundStyle(.ultraThickMaterial)
//                    }
//
//                    VStack {                                    // VStack 3
//                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
//                            .foregroundColor(Color(hue: CGFloat(hue.angle - hue.step) / 360.0, saturation: 1.09, brightness: 1.0)) // Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
//                        //                            .overlay {
//                        //                                Text("\(CGFloat(hue.angle - hue.step) / 360.0)")
//                        //                                    .foregroundStyle(.regularMaterial)
//                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
//
//                            .aspectRatio(1.0, contentMode: .fit)
//                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
//                            .foregroundColor(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.09, brightness: 1.0)) //.foregroundStyle(Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
//                        //                            .overlay {
//                        //                                Text("\(CGFloat(hue.angle) / 360.0)")
//                        //                                    .foregroundStyle(.regularMaterial)
//                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
//                        //                            }
//                            .aspectRatio(1.0, contentMode: .fit)
//                        RoundedRectangle(cornerRadius: max(30.0, (size.width * 0.375) * 0.075), style: .circular)
//                            .foregroundColor(Color(hue: CGFloat(hue.angle + hue.step) / 360.0, saturation: 1.09, brightness: 1.0)) //.foregroundStyle(Color(hue: CGFloat(1.0 / hue.angle), saturation: 1.0, brightness: 1.0))
//                        //                            .overlay {
//                        //                                Text("\(CGFloat(hue.angle + hue.step) / 360.0)")
//                        //                                    .foregroundStyle(.regularMaterial)
//                        //                                    .font(.footnote).dynamicTypeSize(.xSmall)
//                        //                            }
//                            .aspectRatio(1.0, contentMode: .fit)
//                        Stepper("\(hue.step)", value: $hue.step, in: 0...360, step: 1)
//                    }                                           // VStack 3
//                    HStack {                                    // HStack 4
//                        Chart {
//                            ForEach(1...12, id: \.self) { index in
//                                let yValue = Double(index - 1) / 11.0
//                                PointMark(
//                                    x: .value("Month", index),
//                                    y: .value("Value", yValue)
//                                )
//                                .foregroundStyle(.blue)
//                                .symbol(Circle().strokeBorder())
//                                .annotation(position: .top, alignment: .center) {
//                                    Text(String(format: "%.8f", yValue))
//                                }
//                            }
//                        }
//                        .chartXScale(domain: .automatic(includesZero: false))  // Ensures x-axis starts at 1
//                        .chartXAxis {
//                            AxisMarks(preset: .extended, position: .bottom) {
//                                AxisGridLine()
//                                AxisTick()
//                                AxisValueLabel()
//                            }
//                        }
//                        .chartYAxis {
//                            AxisMarks(preset: .extended, position: .leading)
//                        }
//                    }                                            // HStack 4
//                })                                               // HStack 2
//            }                                                    // VStack 1
//
//            //                    Chart {
//            //                        ForEach(intensities) { intensity in
//            //                            PointMark(
//            //                                x: .value("\(intensity.position)", intensity.position),
//            //                                y: .value("\(intensity.value)", intensity.value)
//            //                            )
//            //                            LineMark(
//            //                                x: .value("\(intensity.position)", intensity.position),
//            //                                y: .value("\(intensity.value)", intensity.value)
//            //                            )
//            //                            AxisMarks(values: <#T##[Plottable]#>)
//            //                        }
//            //                    }
//            //                       })
//
//            VStack {
//                HStack(alignment: .center, spacing: 6.0, content: {
//                    let startingAngle  = (CGFloat(hue.angle / 360.0) - CGFloat(hue.step / 360.0))
//                    let angleIncrement = abs((CGFloat(hue.angle / 360.0) - CGFloat(hue.step / 360.0)) - (CGFloat(hue.angle / 360.0) + CGFloat(hue.step / 360.0))) / 12
//
//                    ForEach(intensities) { intensity in
//                        var angleMultipler = CGFloat(intensity.position) // angle multiplier
//                        var hueAngle       = startingAngle + (angleIncrement * angleMultipler)
//                        /*
//
//                         WARNING: Choosing a hue and step that crosses the 360· boundary will mess things up
//
//                         */
//                        RoundedRectangle(cornerRadius: 12.0, style: .circular)
//                            .foregroundStyle(Color(hue: hueAngle, saturation: 1.0, brightness: 1.0))
//                            .aspectRatio(1.0, contentMode: .fit)
//                            .overlay {
//                                Text("\(intensity.position)\n\(abs(CGFloat(hue.angle + (intensity.value * CGFloat(intensity.position)))))")
//                                    .foregroundStyle(.regularMaterial)
//                                    .font(.footnote).dynamicTypeSize(.xSmall)
//                            }
//                    }
//                })
//                HStack(alignment: .center, spacing: 6.0, content: {
//                    ForEach(intensities) { intensity in
//                        RoundedRectangle(cornerRadius: 12.0, style: .circular)
//                            .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: abs(intensity.value + 1.0)))
//                            .aspectRatio(1.0, contentMode: .fit)
//                            .overlay {
//                                Text("\(intensity.position)\n\(abs(intensity.value + 1.0))")
//                                    .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: abs(intensity.value), brightness: 1.0))
//                                    .font(.footnote).dynamicTypeSize(.xSmall)
//                            }
//                    }
//                })
//                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 6.0, content: {
//                    ForEach(intensities) { intensity in
//                        RoundedRectangle(cornerRadius: 12.0, style: .circular)
//                            .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: abs(intensity.value), brightness: 1.0))
//                            .aspectRatio(1.0, contentMode: .fit)
//                            .overlay {
//                                Text("\(intensity.position)\n\(-intensity.value)")
//                                    .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: abs(intensity.value + 1.0)))
//                                    .font(.footnote).dynamicTypeSize(.xSmall)
//                            }
//                    }
//                })
//            }
//        }
//        }

//        func scaleBatch(data: [Double], newMin: Double, newMax: Double) -> [Double] {
//            guard let oldMin = data.min(), let oldMax = data.max(), oldMax != oldMin else { return data }
//            return data.map { newMin + (newMax - newMin) * ($0 - oldMin) / (oldMax - oldMin) }
//        }
//    }

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
