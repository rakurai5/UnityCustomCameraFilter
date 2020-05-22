using UnityEngine;

[ExecuteInEditMode]
public class VHSEffect : CustomImageEffectBase
{
    #region Fields
    [SerializeField]
    private float OffsetRange = 0.10f;

    [SerializeField]
    private float OffsetIntensity = 0.01f;

    [SerializeField]
    private float NoiseQuality = 350.0f;

    [SerializeField]
    private float NoiseIntensity = 0.005f;

    [SerializeField]
    private float ColorOffsetIntensity = 0.25f;

    [SerializeField]
    private float ScanSpeed = 100.0f;

    [SerializeField]
    [Range(0.0f, 1.0f)]
    private float ScanPower = 0.0f;

    #endregion

    #region Properties

    public override string ShaderName
    {
        get { return "CustomFilter/VHS"; }
    }

    #endregion

    #region Methods

    protected override void UpdateMaterial()
    {

        Material.SetFloat("_range", OffsetRange);
        Material.SetFloat("_noiseQuality", NoiseQuality);
        Material.SetFloat("_noiseIntensity", NoiseIntensity);
        Material.SetFloat("_offsetIntensity", OffsetIntensity);
        Material.SetFloat("_colorOffsetIntensity", ColorOffsetIntensity);
        Material.SetFloat("_ScanSpeed", ScanSpeed);
        Material.SetFloat("_ScanPower", ScanPower);


    }

    #endregion

}
