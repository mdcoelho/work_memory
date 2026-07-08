import Cocoa
import Carbon.HIToolbox
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var quickEntryHotKey: QuickEntryHotKey?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    configureQuickEntryChannel(flutterViewController: flutterViewController)

    super.awakeFromNib()
  }

  private func configureQuickEntryChannel(flutterViewController: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "work_memory/quick_entry",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    quickEntryHotKey = QuickEntryHotKey(channel: channel, window: self)
  }
}

final class QuickEntryHotKey {
  private weak var window: NSWindow?
  private let channel: FlutterMethodChannel
  private var hotKeyRef: EventHotKeyRef?
  private var eventHandlerRef: EventHandlerRef?

  init(channel: FlutterMethodChannel, window: NSWindow) {
    self.channel = channel
    self.window = window
    installEventHandler()

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(false)
        return
      }

      switch call.method {
      case "registerShortcut":
        guard
          let arguments = call.arguments as? [String: Any],
          let key = arguments["key"] as? String
        else {
          result(FlutterError(
            code: "invalid_shortcut",
            message: "Shortcut arguments are invalid.",
            details: nil))
          return
        }

        let shortcut = Shortcut(
          key: key,
          meta: arguments["meta"] as? Bool ?? false,
          control: arguments["control"] as? Bool ?? false,
          alt: arguments["alt"] as? Bool ?? false,
          shift: arguments["shift"] as? Bool ?? false)
        result(self.register(shortcut: shortcut))
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  deinit {
    unregister()
    if let eventHandlerRef = eventHandlerRef {
      RemoveEventHandler(eventHandlerRef)
    }
  }

  private func installEventHandler() {
    var eventType = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard),
      eventKind: UInt32(kEventHotKeyPressed))

    InstallEventHandler(
      GetApplicationEventTarget(),
      { (_, event, userData) -> OSStatus in
        guard let userData = userData else {
          return OSStatus(eventNotHandledErr)
        }

        var hotKeyID = EventHotKeyID()
        GetEventParameter(
          event,
          EventParamName(kEventParamDirectObject),
          EventParamType(typeEventHotKeyID),
          nil,
          MemoryLayout<EventHotKeyID>.size,
          nil,
          &hotKeyID)

        guard hotKeyID.signature == QuickEntryHotKey.signature else {
          return OSStatus(eventNotHandledErr)
        }

        let manager = Unmanaged<QuickEntryHotKey>
          .fromOpaque(userData)
          .takeUnretainedValue()
        manager.openQuickEntry()
        return noErr
      },
      1,
      &eventType,
      Unmanaged.passUnretained(self).toOpaque(),
      &eventHandlerRef)
  }

  private func register(shortcut: Shortcut) -> Bool {
    unregister()

    guard let keyCode = Self.keyCode(for: shortcut.key) else {
      return false
    }

    var modifiers: UInt32 = 0
    if shortcut.meta { modifiers |= UInt32(cmdKey) }
    if shortcut.control { modifiers |= UInt32(controlKey) }
    if shortcut.alt { modifiers |= UInt32(optionKey) }
    if shortcut.shift { modifiers |= UInt32(shiftKey) }

    guard modifiers != 0 else {
      return false
    }

    let hotKeyID = EventHotKeyID(signature: Self.signature, id: 1)
    let status = RegisterEventHotKey(
      UInt32(keyCode),
      modifiers,
      hotKeyID,
      GetApplicationEventTarget(),
      0,
      &hotKeyRef)
    return status == noErr
  }

  private func unregister() {
    if let hotKeyRef = hotKeyRef {
      UnregisterEventHotKey(hotKeyRef)
      self.hotKeyRef = nil
    }
  }

  private func openQuickEntry() {
    DispatchQueue.main.async { [weak self] in
      NSApp.activate(ignoringOtherApps: true)
      self?.window?.makeKeyAndOrderFront(nil)
      self?.channel.invokeMethod("quickEntry", arguments: nil)
    }
  }

  private static let signature = fourCharCode("WMQE")

  private static func fourCharCode(_ string: String) -> OSType {
    var result: UInt32 = 0
    for scalar in string.unicodeScalars {
      result = (result << 8) + scalar.value
    }
    return result
  }

  private static func keyCode(for key: String) -> Int? {
    switch key.lowercased() {
    case "space": return kVK_Space
    case "enter": return kVK_Return
    case "tab": return kVK_Tab
    case "escape": return kVK_Escape
    case "backspace": return kVK_Delete
    case "a": return kVK_ANSI_A
    case "b": return kVK_ANSI_B
    case "c": return kVK_ANSI_C
    case "d": return kVK_ANSI_D
    case "e": return kVK_ANSI_E
    case "f": return kVK_ANSI_F
    case "g": return kVK_ANSI_G
    case "h": return kVK_ANSI_H
    case "i": return kVK_ANSI_I
    case "j": return kVK_ANSI_J
    case "k": return kVK_ANSI_K
    case "l": return kVK_ANSI_L
    case "m": return kVK_ANSI_M
    case "n": return kVK_ANSI_N
    case "o": return kVK_ANSI_O
    case "p": return kVK_ANSI_P
    case "q": return kVK_ANSI_Q
    case "r": return kVK_ANSI_R
    case "s": return kVK_ANSI_S
    case "t": return kVK_ANSI_T
    case "u": return kVK_ANSI_U
    case "v": return kVK_ANSI_V
    case "w": return kVK_ANSI_W
    case "x": return kVK_ANSI_X
    case "y": return kVK_ANSI_Y
    case "z": return kVK_ANSI_Z
    case "0": return kVK_ANSI_0
    case "1": return kVK_ANSI_1
    case "2": return kVK_ANSI_2
    case "3": return kVK_ANSI_3
    case "4": return kVK_ANSI_4
    case "5": return kVK_ANSI_5
    case "6": return kVK_ANSI_6
    case "7": return kVK_ANSI_7
    case "8": return kVK_ANSI_8
    case "9": return kVK_ANSI_9
    default: return nil
    }
  }
}

private struct Shortcut {
  let key: String
  let meta: Bool
  let control: Bool
  let alt: Bool
  let shift: Bool
}
