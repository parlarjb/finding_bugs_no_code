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

fact "every resource has an account" {
   // the set of resources owned by any Account
   // must be equal to the complete set of Resources
   Account.resources = Resource

   // there is no combination of two Accounts `a1` and `a2` such that
  no disj a1, a2: Account |
	// `a1` and `a2` both own at least one of the same Resource
	// (i.e. no intersection between their Resources)
	some a1.resources & a2.resources
}

check NoSharedResources {
  // I believe that for every Resource `r`
  all r: Resource |
	// there is exactly one Account `a` for which
	 one a: Account | 
		// `r` belongs to `a`
		r in a.resources
}
