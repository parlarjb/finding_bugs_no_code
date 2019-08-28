one sig Person {
}

sig Resource {
  access: set Person,

  // lone means "zero or one", so each resource has zero parents, or one parent
  parent: lone Resource 
}

//A nice thing about no-cycles is that you can say
// "how are we storing groups in the database? 
// Is it just a parent id on the sql table? Then you can have cycles"
fact "No cycles" {
  no r: Resource |
	r in r.^parent
}


pred can_access(p: Person, r: Resource) {	
       p in (r.access + r.parent.access)
}
