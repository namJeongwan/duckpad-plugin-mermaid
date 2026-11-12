import Foundation

@_silgen_name("duckpad_mermaid_javascript") private func mermaidJavaScript(_ length: UnsafeMutablePointer<Int>) -> UnsafePointer<UInt8>

@MainActor final class MermaidRenderer: DiagramRendering {
    let hasRuntimeSettings = false
    private let web: DiagramWebRenderer
    init() {
        var length = 0
        let bytes = mermaidJavaScript(&length)
        web = DiagramWebRenderer(mermaidRuntime: String(decoding: UnsafeBufferPointer(start: bytes, count: length), as: UTF8.self))
    }
    func render(_ source: String, dark: Bool, runtimePath: String, install: Bool) async throws -> DiagramRender {
        try await web.render(kind: "mermaid", source: source, dark: dark)
    }
    func cancel() { web.cancel() }
}

@MainActor func makeDiagramPlugin(host: DuckpadHost, config: [String: String]) -> DiagramPlugin {
    DiagramPlugin(host: host, config: config, definition: .init(name: "Mermaid", fileExtensions: ["mmd", "mermaid"], sample: "flowchart LR\n  Client --> Server"), renderer: MermaidRenderer())
}
