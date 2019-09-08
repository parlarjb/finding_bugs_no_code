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

fact "parent resource in same account" {
  // For each Resource r
  all r: Resource | 
        // if r has a parent it implies that
	some r.parent implies
                 // there is exactly one Account `a` 
		 (one a: Account | 
			// for which `r` and `r.parent` both belong to `a`
			r in a.resources and r.parent in a.resources)
}

fact "No cycles" {
  // there is no Resource `r` for which
  no r: Resource |
	// `r` is in its own parent chain
	r in r.^parent
}

fact "only permit owning resources in same account" {
  // for every combination of User `u` and Account `a`
  all u: User, a: Account | 
	// if `u` belongs to `a` it implies all of the Resources that `u`
	// has access to belong to `a`
        u in a.users implies u.resources in a.resources
}


run {} for 2 but exactly 2 Account

