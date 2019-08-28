one sig Person {
}

sig Resource {
  access: set Person,

  // lone means "zero or one", so each resource has zero parents, or one parent
  parent: lone Resource 
}
