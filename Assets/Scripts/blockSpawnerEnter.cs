using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class blockSpawnerEnter : MonoBehaviour
{
    public Rigidbody spawnBody;
    public Transform spawnTrans;
    public Transform instanceParent;

    public Renderer ball;
    public Renderer circle;
    public Material pinkMat;
    public Material blueMat;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("block"))
        {
            Debug.Log("others enter");
            Rigidbody newBlock = Instantiate(other.attachedRigidbody, spawnTrans.position, spawnTrans.rotation, instanceParent);
            newBlock.isKinematic = false;

            ball.material = pinkMat;
            circle.material = pinkMat;
        }
    }
    private void OnTriggerExit(Collider other)
    {
        ball.material = blueMat;
        circle.material = blueMat;
        Debug.Log("others exit");
    }
}
