package b

import a._
import example.messages.Greeting

object B {
  val b = A.unit
  val greeting = Greeting("A")
}
