pragma solidity ^0.8.19;

/// based on https://github.com/Consensys/daedaluzz/blob/master/generated-mazes/maze-0.foundry.sol
/// automatically generated by Daedaluzz
contract DaedaluzzFoundryMaze0 {
  event AssertionFailed(string message);
  uint64 private x;
  uint64 private y;
  mapping (uint64 => bool) public found;
  function moveNorth(uint64 p0, uint64 p1, uint64 p2, uint64 p3, uint64 p4, uint64 p5, uint64 p6, uint64 p7) payable external returns (int64) {
    uint64 ny = y + 1;
    require(ny < 7);
    int64 r = step(x, ny, p0, p1, p2, p3, p4, p5, p6, p7);
    if (0 <= r) { y = ny; }
    return r;
  }
  function moveSouth(uint64 p0, uint64 p1, uint64 p2, uint64 p3, uint64 p4, uint64 p5, uint64 p6, uint64 p7) payable external returns (int64) {
    require(0 < y);
    uint64 ny = y - 1;
    int64 r = step(x, ny, p0, p1, p2, p3, p4, p5, p6, p7);
    if (0 <= r) { y = ny; }
    return r;
  }
  function moveEast(uint64 p0, uint64 p1, uint64 p2, uint64 p3, uint64 p4, uint64 p5, uint64 p6, uint64 p7) payable external returns (int64) {
    uint64 nx = x + 1;
    require(nx < 7);
    int64 r = step(nx, y, p0, p1, p2, p3, p4, p5, p6, p7);
    if (0 <= r) { x = nx; }
    return r;
  }
  function moveWest(uint64 p0, uint64 p1, uint64 p2, uint64 p3, uint64 p4, uint64 p5, uint64 p6, uint64 p7) payable external returns (int64) {
    require(0 < x);
    uint64 nx = x - 1;
    int64 r = step(nx, y, p0, p1, p2, p3, p4, p5, p6, p7);
    if (0 <= r) { x = nx; }
    return r;
  }
  function step(uint64 x, uint64 y, uint64 p0, uint64 p1, uint64 p2, uint64 p3, uint64 p4, uint64 p5, uint64 p6, uint64 p7) internal returns (int64) {
    unchecked {
      if (x == 0 && y == 0) {
        // start
        return 0;
      }
      if (x == 0 && y == 1) {
        if (p2 != p2) {
          if (p0 < p5) {
            if (p0 != uint64(46)) {
              if (p4 != uint64(27)) {
                if (p2 < uint64(uint64(61) * p3)) {
                  if (p2 < uint64(49)) {
                    found[1] = true; return -1;  // bug
                  }
                }
              }
            }
          }
        }
        return 1;
      }
      if (x == 0 && y == 2) {
        if (p0 >= p4) {
          if (p4 > uint64(p4 * p6)) {
            if (p0 > uint64(uint64(27) * p2)) {
              if (p4 > uint64(20)) {
                if (p7 < uint64(49)) {
                  if (p1 == uint64(uint64(7) + p2)) {
                    if (p3 <= uint64(33)) {
                      if (p4 >= uint64(uint64(22) + p3)) {
                        if (p2 <= uint64(uint64(12) * p7)) {
                          if (p1 < p7) {
                            if (p4 > uint64(p2 + p5)) {
                              found[2] = true; return -1;  // bug
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 2;
      }
      if (x == 0 && y == 3) {
        if (p7 <= uint64(p6 + p6)) {
          if (p3 <= uint64(uint64(64) * p2)) {
            if (p4 <= uint64(34)) {
              if (p0 >= uint64(uint64(28) * p2)) {
                if (p4 > uint64(37)) {
                  if (p5 >= uint64(p5 * p6)) {
                    if (p7 == uint64(uint64(20) * p6)) {
                      if (p2 >= uint64(48)) {
                        if (p3 >= uint64(p0 + p0)) {
                          if (p3 <= uint64(4)) {
                            if (p7 < uint64(p7 + p5)) {
                              if (p1 != uint64(58)) {
                                if (p4 >= uint64(47)) {
                                  found[3] = true; return -1;  // bug
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 3;
      }
      if (x == 0 && y == 4) {
        if (p2 != uint64(37)) {
          if (p1 <= uint64(p1 + p5)) {
            if (p1 > uint64(2)) {
              if (p0 == uint64(uint64(13) * p3)) {
                if (p2 == uint64(p2 * p7)) {
                  if (p4 == uint64(28)) {
                    if (p3 > uint64(31)) {
                      if (p4 < uint64(uint64(40) * p4)) {
                        found[4] = true; return -1;  // bug
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 4;
      }
      if (x == 0 && y == 5) {
        if (p6 != uint64(uint64(2) + p1)) {
          if (p4 == uint64(p5 * p5)) {
            found[5] = true; return -1;  // bug
          }
        }
        return 5;
      }
      if (x == 0 && y == 6) {
        if (p6 >= uint64(uint64(39) * p5)) {
          if (p4 >= uint64(uint64(55) * p4)) {
            if (p4 <= uint64(p6 * p6)) {
              if (p2 == uint64(uint64(12) + p4)) {
                if (p0 <= uint64(uint64(18) * p2)) {
                  if (p1 >= uint64(57)) {
                    if (p6 >= uint64(41)) {
                      found[6] = true; return -1;  // bug
                    }
                  }
                }
              }
            }
          }
        }
        return 6;
      }
      if (x == 1 && y == 0) {
        require(false);  // wall
        return 7;
      }
      if (x == 1 && y == 1) {
        if (p7 <= uint64(p6 + p5)) {
          if (p0 >= uint64(uint64(62) + p2)) {
            if (p2 == uint64(p3 * p3)) {
              if (p0 >= uint64(24)) {
                if (p2 >= uint64(p7 + p6)) {
                  if (p1 >= p2) {
                    if (p1 == uint64(p4 * p3)) {
                      if (p0 < uint64(uint64(54) * p2)) {
                        found[8] = true; return -1;  // bug
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 8;
      }
      if (x == 1 && y == 2) {
        if (p0 < p4) {
          if (p7 <= p7) {
            if (p0 < uint64(p0 * p4)) {
              if (p7 >= uint64(p2 + p1)) {
                if (p6 >= p6) {
                  if (p4 > uint64(p7 * p4)) {
                    if (p3 < uint64(29)) {
                      found[9] = true; return -1;  // bug
                    }
                  }
                }
              }
            }
          }
        }
        return 9;
      }
      if (x == 1 && y == 3) {
        if (p3 != uint64(41)) {
          if (p7 == uint64(uint64(46) + p4)) {
            if (p6 == p1) {
              if (p3 >= uint64(p4 * p6)) {
                if (p5 < uint64(p7 * p5)) {
                  if (p4 == p3) {
                    if (p5 > uint64(p4 + p3)) {
                      if (p3 != uint64(uint64(53) + p6)) {
                        if (p5 >= uint64(p2 * p7)) {
                          if (p2 == uint64(21)) {
                            if (p6 > uint64(uint64(43) * p3)) {
                              if (p1 == uint64(p7 * p4)) {
                                if (p5 <= uint64(uint64(8) * p0)) {
                                  if (p7 > uint64(17)) {
                                    if (p4 < uint64(p7 * p1)) {
                                      if (p5 > uint64(p1 * p0)) {
                                        found[10] = true; return -1;  // bug
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 10;
      }
      if (x == 1 && y == 4) {
        if (p6 < uint64(p2 * p6)) {
          if (p3 == uint64(p3 * p2)) {
            if (p2 != uint64(p4 * p4)) {
              if (p3 > uint64(uint64(61) + p4)) {
                if (p7 > uint64(p7 * p4)) {
                  if (p1 < uint64(uint64(9) * p0)) {
                    if (p1 != uint64(p2 * p7)) {
                      found[11] = true; return -1;  // bug
                    }
                  }
                }
              }
            }
          }
        }
        return 11;
      }
      if (x == 1 && y == 5) {
        require(false);  // wall
        return 12;
      }
      if (x == 1 && y == 6) {
        if (p0 <= uint64(uint64(51) + p3)) {
          if (p4 != uint64(uint64(31) + p7)) {
            if (p5 < uint64(p2 * p4)) {
              if (p0 > uint64(46)) {
                if (p6 == uint64(11)) {
                  if (p0 == uint64(50)) {
                    if (p3 <= p0) {
                      if (p5 < uint64(41)) {
                        found[13] = true; return -1;  // bug
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 13;
      }
      if (x == 2 && y == 0) {
        if (p5 >= p2) {
          if (p3 <= uint64(p0 * p4)) {
            if (p2 > p2) {
              if (p7 <= uint64(p0 + p6)) {
                if (p6 <= uint64(uint64(26) + p1)) {
                  if (p6 != uint64(uint64(21) * p6)) {
                    if (p5 != uint64(uint64(42) * p0)) {
                      if (p1 < uint64(p6 + p1)) {
                        if (p1 <= uint64(25)) {
                          if (p5 <= uint64(uint64(0) * p6)) {
                            if (p3 == uint64(p2 + p2)) {
                              if (p3 < p7) {
                                found[14] = true; return -1;  // bug
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 14;
      }
      if (x == 2 && y == 1) {
        if (p3 != uint64(6)) {
          if (p3 < p3) {
            if (p3 < uint64(p4 + p7)) {
              if (p5 < uint64(p1 + p7)) {
                if (p4 > uint64(uint64(21) + p0)) {
                  if (p0 <= uint64(uint64(60) + p0)) {
                    if (p7 < uint64(uint64(39) * p3)) {
                      if (p2 <= uint64(19)) {
                        if (p7 != uint64(uint64(26) + p0)) {
                          if (p4 > uint64(15)) {
                            if (p0 != uint64(uint64(47) + p1)) {
                              if (p2 != uint64(p2 + p0)) {
                                if (p6 >= uint64(p5 + p6)) {
                                  if (p0 == uint64(p0 * p2)) {
                                    if (p6 < uint64(31)) {
                                      if (p4 <= uint64(p7 * p5)) {
                                        found[15] = true; return -1;  // bug
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 15;
      }
      if (x == 2 && y == 2) {
        if (p5 != uint64(10)) {
          if (p5 != p0) {
            if (p4 >= uint64(p2 * p1)) {
              if (p3 > uint64(uint64(31) + p5)) {
                found[16] = true; return -1;  // bug
              }
            }
          }
        }
        return 16;
      }
      if (x == 2 && y == 3) {
        if (p6 == uint64(10)) {
          if (p5 == uint64(uint64(50) * p5)) {
            if (p0 > uint64(17)) {
              found[17] = true; return -1;  // bug
            }
          }
        }
        return 17;
      }
      if (x == 2 && y == 4) {
        if (p5 >= uint64(p5 * p7)) {
          if (p0 < p1) {
            if (p2 == uint64(p3 + p7)) {
              found[18] = true; return -1;  // bug
            }
          }
        }
        return 18;
      }
      if (x == 2 && y == 5) {
        if (p4 > p2) {
          if (p6 > uint64(40)) {
            if (p1 != uint64(p1 * p1)) {
              if (p4 > uint64(p7 + p5)) {
                found[19] = true; return -1;  // bug
              }
            }
          }
        }
        return 19;
      }
      if (x == 2 && y == 6) {
        require(false);  // wall
        return 20;
      }
      if (x == 3 && y == 0) {
        if (p3 > uint64(uint64(3) * p0)) {
          if (p1 != uint64(13)) {
            if (p1 > uint64(45)) {
              if (p5 > uint64(uint64(39) + p0)) {
                if (p7 == uint64(p2 + p0)) {
                  if (p4 >= uint64(uint64(16) * p1)) {
                    if (p4 == uint64(38)) {
                      if (p0 >= uint64(uint64(52) * p0)) {
                        if (p2 == uint64(p6 * p5)) {
                          if (p2 < uint64(uint64(2) + p1)) {
                            if (p1 <= p1) {
                              if (p2 > p7) {
                                found[21] = true; return -1;  // bug
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 21;
      }
      if (x == 3 && y == 1) {
        require(false);  // wall
        return 22;
      }
      if (x == 3 && y == 2) {
        if (p3 > uint64(p0 + p6)) {
          if (p5 != uint64(p6 + p4)) {
            if (p2 >= uint64(p0 + p6)) {
              if (p4 != uint64(p1 * p6)) {
                if (p6 > uint64(p3 + p4)) {
                  if (p4 > uint64(uint64(29) * p2)) {
                    if (p7 != uint64(p0 + p7)) {
                      if (p3 != uint64(p6 * p5)) {
                        if (p4 != uint64(p3 * p1)) {
                          if (p0 == uint64(55)) {
                            if (p2 >= uint64(uint64(23) * p5)) {
                              if (p1 <= p1) {
                                if (p2 > uint64(p4 * p7)) {
                                  if (p1 <= uint64(uint64(45) * p5)) {
                                    if (p4 > uint64(p7 + p7)) {
                                      if (p3 > uint64(uint64(54) * p4)) {
                                        found[23] = true; return -1;  // bug
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 23;
      }
      if (x == 3 && y == 3) {
        if (p0 > p2) {
          if (p6 != p6) {
            if (p5 != uint64(p2 + p2)) {
              found[24] = true; return -1;  // bug
            }
          }
        }
        return 24;
      }
      if (x == 3 && y == 4) {
        if (p2 >= uint64(34)) {
          if (p3 <= uint64(9)) {
            if (p1 >= uint64(p2 * p4)) {
              if (p1 == p7) {
                if (p0 > uint64(uint64(57) + p6)) {
                  if (p1 <= uint64(uint64(53) + p4)) {
                    if (p2 >= uint64(uint64(25) * p0)) {
                      if (p6 < uint64(p5 + p6)) {
                        if (p3 >= uint64(uint64(48) * p6)) {
                          if (p7 <= uint64(uint64(23) + p3)) {
                            found[25] = true; return -1;  // bug
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 25;
      }
      if (x == 3 && y == 5) {
        if (p0 > uint64(p1 + p7)) {
          if (p0 == p7) {
            if (p2 != uint64(p6 + p4)) {
              if (p4 >= uint64(47)) {
                if (p5 >= uint64(p5 + p4)) {
                  if (p3 != uint64(28)) {
                    if (p7 == uint64(36)) {
                      if (p5 > uint64(p4 * p4)) {
                        found[26] = true; return -1;  // bug
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 26;
      }
      if (x == 3 && y == 6) {
        if (p7 < uint64(1)) {
          if (p1 > uint64(uint64(8) * p6)) {
            if (p7 <= uint64(uint64(31) * p6)) {
              found[27] = true; return -1;  // bug
            }
          }
        }
        return 27;
      }
      if (x == 4 && y == 0) {
        if (p3 >= uint64(uint64(9) * p7)) {
          if (p5 < uint64(8)) {
            if (p4 != p1) {
              if (p6 >= uint64(uint64(3) * p2)) {
                if (p0 >= uint64(p5 + p3)) {
                  if (p2 < uint64(uint64(63) + p7)) {
                    if (p6 <= uint64(uint64(3) * p4)) {
                      if (p2 <= uint64(46)) {
                        if (p0 != uint64(uint64(42) * p1)) {
                          if (p1 == p5) {
                            found[28] = true; return -1;  // bug
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 28;
      }
      if (x == 4 && y == 1) {
        if (p1 > uint64(63)) {
          if (p0 == uint64(uint64(35) * p2)) {
            if (p0 != uint64(p2 * p6)) {
              found[29] = true; return -1;  // bug
            }
          }
        }
        return 29;
      }
      if (x == 4 && y == 2) {
        if (p4 <= uint64(uint64(31) * p4)) {
          if (p5 < uint64(p5 * p5)) {
            if (p5 > uint64(uint64(41) + p6)) {
              if (p3 >= uint64(uint64(45) + p4)) {
                if (p6 <= uint64(uint64(8) * p7)) {
                  if (p0 < uint64(6)) {
                    if (p2 == uint64(p0 * p3)) {
                      found[30] = true; return -1;  // bug
                    }
                  }
                }
              }
            }
          }
        }
        return 30;
      }
      if (x == 4 && y == 3) {
        if (p0 == uint64(uint64(49) + p5)) {
          if (p2 >= uint64(30)) {
            if (p6 > uint64(uint64(50) * p0)) {
              if (p3 <= uint64(uint64(13) * p1)) {
                if (p5 > uint64(p6 + p2)) {
                  if (p1 <= p5) {
                    if (p4 <= p5) {
                      if (p5 > uint64(uint64(49) * p7)) {
                        if (p2 > uint64(p4 * p3)) {
                          if (p4 != uint64(33)) {
                            if (p2 != uint64(uint64(14) + p5)) {
                              if (p5 <= uint64(25)) {
                                if (p4 < uint64(uint64(52) + p5)) {
                                  if (p1 >= p2) {
                                    found[31] = true; return -1;  // bug
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 31;
      }
      if (x == 4 && y == 4) {
        if (p2 > uint64(39)) {
          if (p2 >= uint64(p5 + p1)) {
            if (p6 >= uint64(p2 * p6)) {
              if (p7 > uint64(5)) {
                if (p0 == uint64(34)) {
                  if (p1 >= uint64(uint64(56) + p3)) {
                    if (p3 == p4) {
                      if (p2 > uint64(uint64(4) * p1)) {
                        if (p2 <= uint64(18)) {
                          if (p5 == uint64(uint64(10) + p0)) {
                            if (p7 <= uint64(p0 * p2)) {
                              if (p3 < uint64(p4 * p7)) {
                                if (p6 == uint64(42)) {
                                  if (p3 < uint64(p6 * p7)) {
                                    if (p5 != uint64(p1 * p2)) {
                                      found[32] = true; return -1;  // bug
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 32;
      }
      if (x == 4 && y == 5) {
        if (p7 <= p4) {
          if (p4 >= uint64(p7 * p6)) {
            if (p5 <= p6) {
              if (p4 <= p1) {
                if (p2 != uint64(p2 * p7)) {
                  if (p0 <= uint64(p4 * p0)) {
                    if (p6 <= p1) {
                      if (p0 < uint64(p6 + p1)) {
                        if (p7 <= p7) {
                          if (p0 >= uint64(uint64(61) * p4)) {
                            if (p2 < uint64(p0 * p3)) {
                              if (p1 == p0) {
                                if (p3 == uint64(uint64(59) * p0)) {
                                  if (p3 <= uint64(uint64(16) + p6)) {
                                    if (p4 == uint64(p2 * p1)) {
                                      if (p7 < uint64(5)) {
                                        found[33] = true; return -1;  // bug
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 33;
      }
      if (x == 4 && y == 6) {
        if (p4 <= uint64(uint64(4) + p1)) {
          if (p6 < uint64(uint64(63) + p3)) {
            if (p5 >= uint64(uint64(30) * p5)) {
              if (p2 != uint64(uint64(27) * p6)) {
                found[34] = true; return -1;  // bug
              }
            }
          }
        }
        return 34;
      }
      if (x == 5 && y == 0) {
        if (p3 >= uint64(55)) {
          if (p4 >= uint64(uint64(52) * p2)) {
            if (p0 != uint64(uint64(56) * p1)) {
              found[35] = true; return -1;  // bug
            }
          }
        }
        return 35;
      }
      if (x == 5 && y == 1) {
        if (p1 > p6) {
          if (p7 < uint64(uint64(34) * p4)) {
            if (p2 == p1) {
              if (p7 >= uint64(32)) {
                if (p1 == uint64(uint64(38) * p1)) {
                  if (p0 > uint64(uint64(52) * p7)) {
                    if (p0 > uint64(uint64(38) + p5)) {
                      if (p3 > uint64(64)) {
                        if (p3 > p6) {
                          if (p3 == p0) {
                            if (p1 > uint64(42)) {
                              if (p6 <= p3) {
                                if (p3 != uint64(uint64(55) * p0)) {
                                  found[36] = true; return -1;  // bug
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 36;
      }
      if (x == 5 && y == 2) {
        if (p4 == uint64(26)) {
          if (p7 < p4) {
            if (p6 > p2) {
              if (p6 > p5) {
                if (p2 > uint64(p0 * p2)) {
                  if (p3 >= uint64(p5 + p7)) {
                    if (p6 < p3) {
                      if (p7 < uint64(46)) {
                        if (p2 < uint64(uint64(44) * p1)) {
                          if (p7 != p0) {
                            if (p5 != uint64(35)) {
                              if (p6 != uint64(p2 + p2)) {
                                found[37] = true; return -1;  // bug
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 37;
      }
      if (x == 5 && y == 3) {
        if (p2 >= uint64(uint64(6) * p4)) {
          if (p5 <= uint64(uint64(6) + p1)) {
            if (p4 <= p6) {
              if (p5 < uint64(p5 * p2)) {
                if (p2 >= p4) {
                  if (p3 == uint64(43)) {
                    if (p4 <= uint64(uint64(49) + p6)) {
                      if (p3 <= uint64(p0 * p3)) {
                        if (p3 != uint64(uint64(28) + p7)) {
                          if (p2 < uint64(uint64(20) * p1)) {
                            if (p2 != p6) {
                              found[38] = true; return -1;  // bug
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 38;
      }
      if (x == 5 && y == 4) {
        if (p5 < uint64(uint64(59) * p6)) {
          if (p5 <= uint64(32)) {
            if (p3 < uint64(p4 + p1)) {
              if (p5 == uint64(31)) {
                if (p7 == uint64(uint64(36) * p1)) {
                  found[39] = true; return -1;  // bug
                }
              }
            }
          }
        }
        return 39;
      }
      if (x == 5 && y == 5) {
        if (p5 > uint64(uint64(41) + p3)) {
          if (p4 >= p5) {
            if (p6 == uint64(uint64(25) + p5)) {
              if (p0 > uint64(p5 * p3)) {
                if (p7 == uint64(7)) {
                  if (p3 >= uint64(19)) {
                    if (p5 <= uint64(uint64(61) * p5)) {
                      if (p7 < p1) {
                        if (p2 <= p3) {
                          found[40] = true; return -1;  // bug
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 40;
      }
      if (x == 5 && y == 6) {
        if (p7 != uint64(p2 + p3)) {
          if (p2 < uint64(60)) {
            if (p0 < uint64(p4 + p0)) {
              if (p3 != uint64(p4 * p0)) {
                if (p1 <= uint64(33)) {
                  if (p1 >= uint64(p6 + p6)) {
                    if (p4 <= uint64(p2 + p0)) {
                      if (p5 <= uint64(uint64(47) * p7)) {
                        if (p5 != uint64(uint64(12) + p6)) {
                          if (p5 >= uint64(uint64(52) * p2)) {
                            if (p0 <= uint64(p2 * p5)) {
                              if (p3 >= p7) {
                                if (p2 == p4) {
                                  found[41] = true; return -1;  // bug
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 41;
      }
      if (x == 6 && y == 0) {
        if (p4 >= uint64(uint64(34) + p7)) {
          if (p4 != uint64(p7 + p2)) {
            if (p7 <= uint64(p7 * p3)) {
              found[42] = true; return -1;  // bug
            }
          }
        }
        return 42;
      }
      if (x == 6 && y == 1) {
        if (p2 == uint64(p4 + p1)) {
          if (p5 == uint64(uint64(12) + p3)) {
            if (p7 >= uint64(p5 * p3)) {
              found[43] = true; return -1;  // bug
            }
          }
        }
        return 43;
      }
      if (x == 6 && y == 2) {
        if (p5 == uint64(uint64(3) + p5)) {
          if (p0 != uint64(p0 * p1)) {
            found[44] = true; return -1;  // bug
          }
        }
        return 44;
      }
      if (x == 6 && y == 3) {
        if (p0 < uint64(23)) {
          if (p2 >= p0) {
            if (p3 < uint64(uint64(50) * p2)) {
              if (p4 > uint64(p3 + p1)) {
                if (p7 >= uint64(uint64(52) * p5)) {
                  if (p6 <= uint64(p1 * p6)) {
                    if (p1 > uint64(p3 + p7)) {
                      if (p6 < uint64(p5 + p1)) {
                        if (p0 > uint64(uint64(9) + p5)) {
                          if (p6 < p0) {
                            if (p1 > uint64(p0 + p2)) {
                              if (p3 <= uint64(p0 * p0)) {
                                if (p5 != p7) {
                                  if (p1 < uint64(p5 + p0)) {
                                    if (p6 == uint64(p7 + p5)) {
                                      found[45] = true; return -1;  // bug
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 45;
      }
      if (x == 6 && y == 4) {
        if (p7 <= p1) {
          if (p5 < p2) {
            if (p2 != p3) {
              if (p0 > uint64(uint64(39) + p7)) {
                if (p3 <= uint64(p1 * p6)) {
                  if (p2 > uint64(34)) {
                    if (p4 == uint64(uint64(26) * p4)) {
                      if (p3 >= p2) {
                        if (p5 >= uint64(uint64(15) * p3)) {
                          if (p4 == uint64(p1 + p2)) {
                            if (p1 > uint64(uint64(0) + p5)) {
                              if (p4 <= uint64(p7 * p1)) {
                                if (p7 >= uint64(56)) {
                                  if (p4 > uint64(61)) {
                                    if (p7 > uint64(p1 * p6)) {
                                      found[46] = true; return -1;  // bug
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 46;
      }
      if (x == 6 && y == 5) {
        if (p0 > uint64(18)) {
          if (p7 >= uint64(uint64(59) * p0)) {
            if (p0 >= uint64(37)) {
              if (p5 < uint64(uint64(44) * p3)) {
                if (p2 < uint64(p3 * p7)) {
                  if (p0 <= uint64(p3 * p6)) {
                    if (p7 <= p1) {
                      if (p7 >= uint64(uint64(8) + p5)) {
                        if (p5 < uint64(p5 * p3)) {
                          if (p3 < uint64(uint64(55) + p3)) {
                            if (p4 < uint64(41)) {
                              if (p0 >= uint64(uint64(53) + p7)) {
                                if (p4 > uint64(uint64(52) * p1)) {
                                  if (p2 == uint64(p0 + p7)) {
                                    if (p6 > uint64(p0 * p5)) {
                                      if (p6 <= uint64(p4 + p4)) {
                                        found[47] = true; return -1;  // bug
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return 47;
      }
      if (x == 6 && y == 6) {
        require(false);  // wall
        return 48;
      }
      return 49;
    }
  }
}

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract TestDaedaluzzFoundryMaze0 is Test, SymTest {
  DaedaluzzFoundryMaze0 maze;

  function setUp() external {
    maze = new DaedaluzzFoundryMaze0();
  }

  function invariant_01() external view { assert(!maze.found(1)); }
  function invariant_02() external view { assert(!maze.found(2)); }
  function invariant_03() external view { assert(!maze.found(3)); }
  function invariant_04() external view { assert(!maze.found(4)); }
  function invariant_05() external view { assert(!maze.found(5)); }
  function invariant_06() external view { assert(!maze.found(6)); }
  function invariant_07() external view { assert(!maze.found(7)); }
  function invariant_08() external view { assert(!maze.found(8)); }
  function invariant_09() external view { assert(!maze.found(9)); }
  function invariant_10() external view { assert(!maze.found(10)); }
  function invariant_11() external view { assert(!maze.found(11)); }
  function invariant_12() external view { assert(!maze.found(12)); }
  function invariant_13() external view { assert(!maze.found(13)); }
  function invariant_14() external view { assert(!maze.found(14)); }
  function invariant_15() external view { assert(!maze.found(15)); }
  function invariant_16() external view { assert(!maze.found(16)); }
  function invariant_17() external view { assert(!maze.found(17)); }
  function invariant_18() external view { assert(!maze.found(18)); }
  function invariant_19() external view { assert(!maze.found(19)); }
  function invariant_20() external view { assert(!maze.found(20)); }
  function invariant_21() external view { assert(!maze.found(21)); }
  function invariant_22() external view { assert(!maze.found(22)); }
  function invariant_23() external view { assert(!maze.found(23)); }
  function invariant_24() external view { assert(!maze.found(24)); }
  function invariant_25() external view { assert(!maze.found(25)); }
  function invariant_26() external view { assert(!maze.found(26)); }
  function invariant_27() external view { assert(!maze.found(27)); }
  function invariant_28() external view { assert(!maze.found(28)); }
  function invariant_29() external view { assert(!maze.found(29)); }
  function invariant_30() external view { assert(!maze.found(30)); }
  function invariant_31() external view { assert(!maze.found(31)); }
  function invariant_32() external view { assert(!maze.found(32)); }
  function invariant_33() external view { assert(!maze.found(33)); }
  function invariant_34() external view { assert(!maze.found(34)); }
  function invariant_35() external view { assert(!maze.found(35)); }
  function invariant_36() external view { assert(!maze.found(36)); }
  function invariant_37() external view { assert(!maze.found(37)); }
  function invariant_38() external view { assert(!maze.found(38)); }
  function invariant_39() external view { assert(!maze.found(39)); }
  function invariant_40() external view { assert(!maze.found(40)); }
  function invariant_41() external view { assert(!maze.found(41)); }
  function invariant_42() external view { assert(!maze.found(42)); }
  function invariant_43() external view { assert(!maze.found(43)); }
  function invariant_44() external view { assert(!maze.found(44)); }
  function invariant_45() external view { assert(!maze.found(45)); }
  function invariant_46() external view { assert(!maze.found(46)); }
  function invariant_47() external view { assert(!maze.found(47)); }
  function invariant_48() external view { assert(!maze.found(48)); }
}
