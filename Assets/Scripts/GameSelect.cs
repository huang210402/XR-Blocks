using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameSelect : MonoBehaviour
{
    public int gameSelect = 0;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("G1"))
            gameSelect = 1;
        if (other.CompareTag("G2"))
            gameSelect = 2;
        if (other.CompareTag("G3"))
            gameSelect = 3;
        if (other.CompareTag("G4"))
            gameSelect = 4;
    }
}
