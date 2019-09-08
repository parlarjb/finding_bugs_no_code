sig Account {
  // Every Account has 0 or more Resources
  resources: set Resource,

  // Every Account has 0 or more Users
  users: set User
}

sig User {
  // Every User has direct access to 0 or more Users
  resources: set Resource
}

sig Resource {
  // Every Resource has 0 Parents or 1 Parent
  parent: lone Resource
}

fact "no shared users" {
  // For each User `u`
  all u: User | 
        // there is exactly one Account `a`
	one a: Account | 
		// for which `u` belongs to `a`
		u in a.users
}

run {} for 2 but exactly 2 Account

