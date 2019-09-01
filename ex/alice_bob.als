open util/ordering[Time]
sig Time {}

abstract sig People {
  balance: Int one -> Time
}

one sig Alice, Bob extends People {}

pred init(day0: Time) {
  Alice.balance.day0 = 2
  Bob.balance.day0 = 2
} 

pred transfer(today, tomorrow: Time, amount: Int) {
  (amount >= Alice.balance.today)
    implies (
      Alice.balance.tomorrow = Alice.balance.today - amount
      and Bob.balance.tomorrow = Alice.balance.today + amount
    ) else (
      skip[today, tomorrow]
    )
}

pred skip (today, tomorrow: Time) {
  Alice.balance.tomorrow = Alice.balance.today
  Bob.balance.tomorrow = Bob.balance.today
}

fact Traces {
  init[first]

  all today: Time-last | let tomorrow = today.next | {
    some amount: Int | transfer[today, tomorrow, amount]
    or skip[today, tomorrow]
  
  }
}

run {
  some t, t': Time | Alice.balance.t' != Alice.balance.t
} for 3 but 10 Int
