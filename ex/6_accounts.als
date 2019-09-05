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
  all u: User | one a: Account | u in a.users
}

fact "parent resource in same account" {
  all r: Resource | 
	some r.parent implies
		 (one a: Account | r in a.resources and r.parent in a.resources)
}

fact "No cycles" {
  no r: Resource |
	r in r.^parent
}

fact "only permit resources in same account" {
  all r: Resource | one a: Account | r in a.resources

  all u: User, a: Account | 
        u in a.users implies u.resources in a.resources
}


run {} for 2 but exactly 2 Account

fact "every resource has an account" {
   all r: Resource | one a: Account | r in a.resources
}

check NoSharedResources {
  all r: Resource | one a: Account | r in a.resources
}
