sig Account {
  resources: set Resource,
  users: set User
}

sig User {
  canAccess: set Resource
}

sig Resource {
  parent: lone Resource
}

fact "no shared users or resources" {
  all u: User | one a: Account | u in a.users

  all r: Resource | one a: Account | r in a.resources
}

fact "parent resource in same account" {
  all r: Resource | some r.parent implies (one a: Account | r in a.resources and r.parent in a.resources)
}

fact "No cycles" {
  no r: Resource |
	r in r.^parent
}



run {} for 2 but exactly 2 Account
