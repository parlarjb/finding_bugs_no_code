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
  all u: User, a: Account, r: a.resources | 
 	r in u.resources implies u in a.users
}


run {} for 2 but exactly 2 Account

fact "every resource has an account" {
   all r: Resource | one a: Account | r in a.resources
}

check NoSharedResources {
  all r: Resource | one a: Account | r in a.resources
}

// A user can access all resources they have direct access
// to, and those resources' parent resources
pred can_access(u: User, r: Resource) {	
       r in u.resources or (some r.parent and r.parent in u.resources)
}

//if you can access the parent, you can access all its children
check parent_implies_child {
	all u: User, r: Resource |
		can_access[u, r] implies 
                    all child: parent.r | can_access[u, child]
}
