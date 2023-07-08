using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class blockSpawner : MonoBehaviour
{
    public Rigidbody blockSpawn;
    public Transform spawnTrans;
    public Transform instanceParent;
    private bool isStay;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("block"))
            isStay = true;
    }
    private void OnTriggerExit(Collider other)
    {
        if(other.CompareTag("block") && isStay)
            Instantiate(blockSpawn, spawnTrans.position, spawnTrans.rotation, instanceParent);
            Debug.Log("others exit");
    }
}
