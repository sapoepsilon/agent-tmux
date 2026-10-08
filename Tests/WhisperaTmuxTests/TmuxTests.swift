import XCTest
@testable import WhisperaTmux
final class TmuxTests: XCTestCase {
 func testNamedPanesAndMalformedData() throws {
  let f = ["%7","$2","My project","@3","Fix images","Agent title","/work","codex","1","0"].joined(separator:TmuxClient.separator)
  let sessions = TmuxClient.parseSessions(f+"\nmalformed")
  XCTAssertEqual(sessions.count,1);XCTAssertEqual(sessions[0].name,"Fix images")
  XCTAssertEqual(sessions[0].workspaceName,"My project");XCTAssertEqual(sessions[0].id,"%7")
  XCTAssertEqual(TmuxTUIProvider().keys(for:.cancel),["esc"])
 }
 func testLiteralArgumentsAndRejectInvalidTargets() throws {
  let c = TmuxClient { args in
   if args.contains("-l") { XCTAssertEqual(args.last,"\u{1B}[200~-n $(private)\nsecond line\u{1B}[201~") }
   return ""
  }
  try c.send("-n $(private)\nsecond line",to:"%7")
  XCTAssertThrowsError(try c.send("hello",to:"-a"))
  XCTAssertThrowsError(try c.sendKeys(["run-shell"],to:"%7"))
 }
}
